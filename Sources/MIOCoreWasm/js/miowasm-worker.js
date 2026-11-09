// miowasm-worker.js — run a WebAssembly API in a Web Worker, called with promises from the page.
//
// In the worker script (one per module, a few lines):
//
//   import { serveWasmAPI } from "./miowasm-worker.js";
//   import { DLReportKit } from "./dlreportkit.js";
//   serveWasmAPI( ( url ) => DLReportKit.instantiate( fetch( url ) ) );
//
// In the page:
//
//   import { MIOWasmWorker } from "./miowasm-worker.js";
//   const kit = new MIOWasmWorker( new Worker( "dlreportkit-worker.js", { type: "module" } ) );
//   await kit.init( "DLReportKitWasm.wasm" );
//   const html = await kit.call( "rowsHTML", 0, 0, 50 );
//
// `createAPI(...initArgs)` returns (a promise of) the object whose methods the page calls;
// methods starting with "_" are not callable. Errors come back as rejected promises.

export function serveWasmAPI( createAPI, scope = self ) {
    let api = null;
    scope.onmessage = async ( event ) => {
        const { id, method, args = [] } = event.data || {};
        try {
            let result;
            if ( method === "init" ) {
                api = await createAPI( ...args );
                result = true;
            } else {
                if ( api === null ) throw new Error( "Not initialised: call init first" );
                if ( typeof method !== "string" || method.startsWith( "_" ) || typeof api[ method ] !== "function" ) {
                    throw new Error( "Unknown method " + method );
                }
                result = await api[ method ]( ...args );
            }
            scope.postMessage( { id, result } );
        } catch ( error ) {
            scope.postMessage( { id, error: String( error && error.message || error ) } );
        }
    };
}

export class MIOWasmWorker {

    constructor( worker ) {
        this.worker = worker;
        this.next = 0;
        this.pending = new Map();
        worker.onmessage = ( event ) => {
            const { id, result, error } = event.data || {};
            const p = this.pending.get( id );
            if ( !p ) return;
            this.pending.delete( id );
            if ( error !== undefined ) p.reject( new Error( error ) ); else p.resolve( result );
        };
        worker.onerror = ( event ) => {
            for ( const p of this.pending.values() ) p.reject( new Error( event.message || "Worker error" ) );
            this.pending.clear();
        };
    }

    call( method, ...args ) {
        return new Promise( ( resolve, reject ) => {
            const id = ++this.next;
            this.pending.set( id, { resolve, reject } );
            this.worker.postMessage( { id, method, args } );
        } );
    }

    init( ...args ) { return this.call( "init", ...args ); }

    terminate() { this.worker.terminate(); }
}
