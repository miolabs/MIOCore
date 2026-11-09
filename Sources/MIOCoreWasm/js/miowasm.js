// miowasm.js — the JavaScript half of the MIO WebAssembly convention (Swift half:
// MIOCoreWasm / MCWasm.swift). Loads any module built against MIOCoreWasm, in a page,
// a Web Worker or Node, with no dependencies.
//
//   import { MIOWasm } from "./miowasm.js";
//   const wasm = await MIOWasm.instantiate( fetch( "Module.wasm" ) );
//   wasm.call( "lib_sort", 0, "total", true );          // strings / bytes → (pointer, length)
//   wasm.callString( "lib_rows_html", 0, 0, 50 );       // returned buffer → string
//   wasm.callJSON( "lib_info", 0 );                     // returned buffer → JSON.parse
//
// Convention: the module exports mio_alloc(size) / mio_free(pointer); string and byte
// arguments are passed as (pointer, length) and freed after the call; results that are
// strings / bytes / JSON come back as a pointer to [length: UInt32 LE][bytes], read here and
// freed with mio_free.

const ERRNO_SUCCESS = 0, ERRNO_BADF = 8, ERRNO_NOENT = 44, ERRNO_NOSYS = 52;

/// The WASI preview1 imports a sandboxed module needs: clocks, random, stdout / stderr to
/// the console. No files, sockets or sleeping.
export function wasiShim( getMemory, { prefix = "[wasm]", log = console.log, warn = console.warn } = {} ) {
    const decoder = new TextDecoder();
    const view = () => new DataView( getMemory().buffer );
    const pending = { 1: "", 2: "" };
    const nosys = () => ERRNO_NOSYS;
    return {
        args_sizes_get: ( argc, size ) => { view().setUint32( argc, 0, true ); view().setUint32( size, 0, true ); return ERRNO_SUCCESS; },
        args_get: () => ERRNO_SUCCESS,
        environ_sizes_get: ( count, size ) => { view().setUint32( count, 0, true ); view().setUint32( size, 0, true ); return ERRNO_SUCCESS; },
        environ_get: () => ERRNO_SUCCESS,
        clock_res_get: ( id, res ) => { view().setBigUint64( res, 1000n, true ); return ERRNO_SUCCESS; },
        clock_time_get: ( id, precision, time ) => {
            // 0 realtime, otherwise monotonic; nanoseconds
            const ns = id === 0 ? BigInt( Date.now() ) * 1000000n : BigInt( Math.round( performance.now() * 1e6 ) );
            view().setBigUint64( time, ns, true );
            return ERRNO_SUCCESS;
        },
        random_get: ( buf, len ) => { crypto.getRandomValues( new Uint8Array( getMemory().buffer, buf, len ) ); return ERRNO_SUCCESS; },
        fd_write: ( fd, iovs, iovsLen, written ) => {
            if ( fd !== 1 && fd !== 2 ) return ERRNO_BADF;
            const v = view();
            let total = 0;
            for ( let i = 0; i < iovsLen; i++ ) {
                const ptr = v.getUint32( iovs + i * 8, true ), len = v.getUint32( iovs + i * 8 + 4, true );
                pending[ fd ] += decoder.decode( new Uint8Array( getMemory().buffer, ptr, len ) );
                total += len;
            }
            let nl;
            while ( ( nl = pending[ fd ].indexOf( "\n" ) ) >= 0 ) {
                ( fd === 2 ? warn : log )( prefix + " " + pending[ fd ].slice( 0, nl ) );
                pending[ fd ] = pending[ fd ].slice( nl + 1 );
            }
            v.setUint32( written, total, true );
            return ERRNO_SUCCESS;
        },
        fd_prestat_get: () => ERRNO_BADF,
        fd_prestat_dir_name: () => ERRNO_BADF,
        fd_fdstat_get: ( fd ) => ( fd <= 2 ? ERRNO_SUCCESS : ERRNO_BADF ),
        path_open: () => ERRNO_NOENT,
        proc_exit: ( code ) => { throw new Error( "WebAssembly module exited with code " + code ); },
        fd_close: nosys, fd_fdstat_set_flags: nosys, fd_filestat_get: nosys, fd_filestat_set_size: nosys,
        fd_filestat_set_times: nosys, fd_pread: nosys, fd_read: nosys, fd_readdir: nosys, fd_seek: nosys,
        fd_sync: nosys, fd_tell: nosys, path_create_directory: nosys, path_filestat_get: nosys,
        path_filestat_set_times: nosys, path_link: nosys, path_readlink: nosys, path_remove_directory: nosys,
        path_rename: nosys, path_symlink: nosys, path_unlink_file: nosys, poll_oneoff: nosys,
    };
}

export class MIOWasm {

    /// `source`: a fetch Response (or a promise of one), an ArrayBuffer / Uint8Array, or a
    /// compiled WebAssembly.Module. `options`: { prefix, log, warn } for the module's output.
    static async instantiate( source, options = {} ) {
        let memory = null;
        const imports = { wasi_snapshot_preview1: wasiShim( () => memory, options ) };
        const resolved = await source;
        let instance;
        if ( resolved instanceof WebAssembly.Module ) {
            instance = await WebAssembly.instantiate( resolved, imports );
        } else if ( typeof Response !== "undefined" && resolved instanceof Response ) {
            if ( !resolved.ok ) throw new Error( "Could not load WebAssembly module: HTTP " + resolved.status );
            // Streaming compile needs the server to send application/wasm; other servers
            // (local dev servers, misconfigured hosts) still work from the bytes.
            const streamable = ( resolved.headers.get( "Content-Type" ) || "" ).startsWith( "application/wasm" );
            if ( streamable && typeof WebAssembly.instantiateStreaming === "function" ) {
                instance = ( await WebAssembly.instantiateStreaming( resolved, imports ) ).instance;
            } else {
                instance = ( await WebAssembly.instantiate( await resolved.arrayBuffer(), imports ) ).instance;
            }
        } else {
            instance = ( await WebAssembly.instantiate( resolved, imports ) ).instance;
        }
        memory = instance.exports.memory;
        if ( typeof instance.exports._initialize === "function" ) instance.exports._initialize();
        if ( typeof instance.exports.mio_alloc !== "function" ) throw new Error( "Not a MIOCoreWasm module (no mio_alloc export)" );
        return new MIOWasm( instance );
    }

    constructor( instance ) {
        this.instance = instance;
        this.exports = instance.exports;
        this.encoder = new TextEncoder();
        this.decoder = new TextDecoder();
    }

    get memory() { return this.exports.memory; }

    /// Copies bytes into module memory: [pointer, length]. Free with free(pointer).
    writeBytes( bytes ) {
        const ptr = this.exports.mio_alloc( bytes.length );
        new Uint8Array( this.memory.buffer, ptr, bytes.length ).set( bytes );
        return [ ptr, bytes.length ];
    }

    writeString( text ) { return this.writeBytes( this.encoder.encode( text ?? "" ) ); }

    free( pointer ) { if ( pointer ) this.exports.mio_free( pointer ); }

    /// A [length][bytes] buffer the module returned; frees it.
    readBytes( pointer ) {
        const len = new DataView( this.memory.buffer ).getUint32( pointer, true );
        const bytes = new Uint8Array( this.memory.buffer, pointer + 4, len ).slice();
        this.free( pointer );
        return bytes;
    }

    readString( pointer ) { return this.decoder.decode( this.readBytes( pointer ) ); }

    readJSON( pointer ) { return JSON.parse( this.readString( pointer ) ); }

    /// Calls an export. Strings and Uint8Arrays become (pointer, length) and are freed after
    /// the call; `null` / `undefined` become (0, -1) (MCWasm.optionalString → nil); booleans
    /// become 1 / 0; numbers pass as is. Returns the raw result.
    call( name, ...args ) {
        const fn = this.exports[ name ];
        if ( typeof fn !== "function" ) throw new Error( "No export named " + name );
        const temporary = [];
        const flat = [];
        for ( const a of args ) {
            if ( typeof a === "string" || a instanceof Uint8Array ) {
                const [ ptr, len ] = typeof a === "string" ? this.writeString( a ) : this.writeBytes( a );
                temporary.push( ptr );
                flat.push( ptr, len );
            } else if ( a === null || a === undefined ) {
                flat.push( 0, -1 );
            } else if ( typeof a === "boolean" ) {
                flat.push( a ? 1 : 0 );
            } else {
                flat.push( a );
            }
        }
        try { return fn( ...flat ); }
        finally { for ( const p of temporary ) this.free( p ); }
    }

    callString( name, ...args ) { return this.readString( this.call( name, ...args ) ); }
    callBytes( name, ...args ) { return this.readBytes( this.call( name, ...args ) ); }
    callJSON( name, ...args ) { return this.readJSON( this.call( name, ...args ) ); }
}
