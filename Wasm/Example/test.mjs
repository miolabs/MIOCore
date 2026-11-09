// node test.mjs <Example.wasm>
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";
import { MIOWasm } from "../../Sources/MIOCoreWasm/js/miowasm.js";
import { serveWasmAPI, MIOWasmWorker } from "../../Sources/MIOCoreWasm/js/miowasm-worker.js";

const bytes = readFileSync( process.argv[ 2 ] );
const exportNames = WebAssembly.Module.exports( new WebAssembly.Module( bytes ) ).map( e => e.name );
assert.ok( exportNames.includes( "mio_alloc" ) && exportNames.includes( "mio_free" ) && exportNames.includes( "mio_take_error" ), "standard exports come from MIOCoreWasm" );

const wasm = await MIOWasm.instantiate( bytes );
assert.equal( wasm.callString( "example_echo", "hola, año" ), "HOLA, AÑO" );
assert.deepEqual( wasm.callJSON( "example_sum", JSON.stringify( { values: [ 0.1, 0.2, 1234567890123456.78 ] } ) ), { sum: 1234567890123457.08, count: 3 } );
assert.equal( wasm.callString( "example_optional", null ), "none" );
assert.equal( wasm.callString( "example_optional", "" ), "some:" );
assert.equal( wasm.callString( "example_optional", "x" ), "some:x" );
assert.deepEqual( [ ...wasm.callBytes( "example_reverse", new Uint8Array( [ 1, 2, 3 ] ) ) ], [ 3, 2, 1 ] );
assert.equal( wasm.call( "example_add", 2, 3, true ), -5 );
// errors: recorded by MCWasm.fail, taken (and cleared) with mio_take_error
assert.equal( wasm.call( "example_divide", 9, 3 ), 3 );
assert.equal( wasm.exports.mio_take_error(), 0 );
wasm.call( "example_divide", 9, 0 );
assert.equal( wasm.readString( wasm.exports.mio_take_error() ), "division by zero" );
assert.equal( wasm.exports.mio_take_error(), 0 );
assert.throws( () => wasm.call( "nope" ), /No export/ );

// memory is freed: many calls do not grow it
const before = wasm.memory.buffer.byteLength;
for ( let i = 0; i < 20000; i++ ) wasm.callString( "example_echo", "x".repeat( 200 ) );
assert.equal( wasm.memory.buffer.byteLength, before, "memory did not grow" );

// worker plumbing, with an in-process stand-in for the worker
const worker = { onmessage: null, onerror: null, postMessage( m ) { scope.onmessage( { data: m } ); } };
const scope = { onmessage: null, postMessage( m ) { worker.onmessage( { data: m } ); } };
serveWasmAPI( async () => ( { echo: ( s ) => wasm.callString( "example_echo", s ), _secret: () => 1 } ), scope );
const client = new MIOWasmWorker( worker );
await assert.rejects( client.call( "echo", "a" ), /init first/ );
await client.init();
assert.equal( await client.call( "echo", "abc" ), "ABC" );
await assert.rejects( client.call( "_secret" ), /Unknown method/ );

console.log( "miowasm OK" );
