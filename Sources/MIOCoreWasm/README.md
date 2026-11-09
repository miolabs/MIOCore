# MIOCoreWasm

The shared plumbing for MIO WebAssembly modules (libraries compiled to wasm for the web). It has two halves that follow one convention:

| | |
|---|---|
| `MCWasm.swift` | Swift helpers plus the standard `mio_alloc` / `mio_free` exports. Compiled **only for WASI**; other platforms get an empty module. |
| `js/miowasm.js` | Loads any module that links MIOCoreWasm: a WASI shim, `instantiate`, and string / bytes / JSON passing. Works in a page, a Web Worker or Node. No dependencies. |
| `js/miowasm-worker.js` | Runs a module's API in a Web Worker (`serveWasmAPI`) and calls it from the page with promises (`MIOWasmWorker`). |

The JavaScript files are not built by SwiftPM. A web app copies them next to its `.wasm` and serves them like any static file.

## Convention
- **Memory:** every module exports `mio_alloc(size) -> pointer` and `mio_free(pointer)`. They come from this library, so a module only declares its own functions.
- **Arguments:** strings and bytes go in as (pointer, byte length), in memory JS got from `mio_alloc` and frees after the call. `null` is passed as (0, -1), which `MCWasm.optionalString` reads as `nil`. Booleans pass as 1 / 0; numbers pass as they are.
- **Results:** strings, bytes and JSON come back as a pointer to `[length: UInt32 LE][bytes]`. JS reads it and frees it with `mio_free`.

## Swift side
```swift
// Package.swift: link it for the web build only
.product( name: "MIOCoreWasm", package: "MIOCore", condition: .when( platforms: [.wasi] ) )
// and build as a reactor: linkerSettings: [ .unsafeFlags( [ "-Xclang-linker", "-mexec-model=reactor" ], .when( platforms: [.wasi] ) ) ]

#if os(WASI)
import MIOCoreWasm

@_expose(wasm, "lib_greet")
@_cdecl("lib_greet")
public func lib_greet ( _ name: UnsafeRawPointer?, _ length: Int32 ) -> UnsafeMutableRawPointer {
    MCWasm.buffer( "Hola " + MCWasm.string( name, length ) )
}
#endif
```

## JavaScript side
```js
import { MIOWasm } from "./miowasm.js";
const wasm = await MIOWasm.instantiate( fetch( "Lib.wasm" ) );
wasm.callString( "lib_greet", "Ana" );        // "Hola Ana"
wasm.callJSON( "lib_info", 0 );               // JSON results
```

## Test
`Wasm/Example` is a minimal module, and `test.mjs` checks the whole convention in Node: exports, argument and result types, memory staying stable over 20,000 calls, and the worker RPC.

```bash
cd Wasm/Example
swiftly run swift build --swift-sdk swift-6.3.3-RELEASE_wasm -c release +6.3.3
node test.mjs .build/release/Example.wasm
```
