//
//  MCWasm.swift
//  MIOCoreWasm
//
//  The Swift half of the MIO WebAssembly convention (the JavaScript half is js/miowasm.js):
//
//  - Memory: every module exports `mio_alloc(size) -> pointer` and `mio_free(pointer)`
//    (defined here, so a module that links MIOCoreWasm exports them automatically).
//  - Inputs: strings and bytes arrive as (pointer, byte length) of memory JS got from
//    mio_alloc; JS frees it after the call.
//  - Outputs: strings, bytes and JSON go back as one buffer, `[length: UInt32 LE][bytes]`,
//    allocated here; JS reads it and calls mio_free.
//  - Errors: a failed call records its error with `MCWasm.fail`; JS takes it with
//    `mio_take_error()` (a buffer with the message, or 0 when there is none) and throws.
//
//  Compiled only for WASI: other platforms get an empty module.
//

#if os(WASI)

import Foundation

public enum MCWasm {

    // MARK: Inputs

    /// UTF-8 text JS wrote at (`pointer`, `length`); "" when empty.
    public static func string ( _ pointer: UnsafeRawPointer?, _ length: Int32 ) -> String {
        guard let pointer = pointer, length > 0 else { return "" }
        return String( decoding: UnsafeRawBufferPointer( start: pointer, count: Int( length ) ), as: UTF8.self )
    }

    /// Optional text: nil when JS passed no string (length < 0 or null pointer).
    public static func optionalString ( _ pointer: UnsafeRawPointer?, _ length: Int32 ) -> String? {
        guard pointer != nil, length >= 0 else { return nil }
        return string( pointer, length )
    }

    /// Bytes JS wrote at (`pointer`, `length`).
    public static func data ( _ pointer: UnsafeRawPointer?, _ length: Int32 ) -> Data {
        guard let pointer = pointer, length > 0 else { return Data( ) }
        return Data( bytes: pointer, count: Int( length ) )
    }

    /// A JSON value JS wrote as UTF-8 text.
    public static func json<T: Decodable> ( _ type: T.Type, _ pointer: UnsafeRawPointer?, _ length: Int32 ) throws -> T {
        try JSONDecoder( ).decode( type, from: data( pointer, length ) )
    }

    // MARK: Outputs

    /// A `[length: UInt32 LE][bytes]` buffer for JS (it frees it with mio_free).
    public static func buffer ( _ bytes: UnsafeRawBufferPointer ) -> UnsafeMutableRawPointer {
        let pointer = UnsafeMutableRawPointer.allocate( byteCount: 4 + bytes.count, alignment: 8 )
        pointer.storeBytes( of: UInt32( bytes.count ).littleEndian, as: UInt32.self )
        if let base = bytes.baseAddress, bytes.count > 0 {
            pointer.advanced( by: 4 ).copyMemory( from: base, byteCount: bytes.count )
        }
        return pointer
    }

    public static func buffer ( _ text: String ) -> UnsafeMutableRawPointer {
        var text = text
        return text.withUTF8 { buffer( UnsafeRawBufferPointer( $0 ) ) }
    }

    public static func buffer ( _ data: Data ) -> UnsafeMutableRawPointer {
        data.withUnsafeBytes { buffer( $0 ) }
    }

    /// `value` as JSON text ("null" if it cannot be encoded).
    public static func buffer<T: Encodable> ( json value: T ) -> UnsafeMutableRawPointer {
        buffer( ( try? JSONEncoder( ).encode( value ) ) ?? Data( "null".utf8 ) )
    }

    // MARK: Errors

    nonisolated(unsafe) static var lastError: String?

    /// Records why the current call failed, for JS to read with mio_take_error.
    public static func fail ( _ error: Error ) {
        lastError = String( describing: error )
    }

    public static func fail ( _ message: String ) {
        lastError = message
    }

    /// The recorded error, cleared.
    public static func takeError ( ) -> String? {
        defer { lastError = nil }
        return lastError
    }
}

// MARK: - Standard exports

@_expose(wasm, "mio_alloc")
@_cdecl("mio_alloc")
public func mio_alloc ( _ size: Int32 ) -> UnsafeMutableRawPointer {
    UnsafeMutableRawPointer.allocate( byteCount: Int( max( size, 1 ) ), alignment: 8 )
}

@_expose(wasm, "mio_free")
@_cdecl("mio_free")
public func mio_free ( _ pointer: UnsafeMutableRawPointer? ) {
    pointer?.deallocate( )
}

/// The error the last failed call recorded (a buffer), or 0; clears it.
@_expose(wasm, "mio_take_error")
@_cdecl("mio_take_error")
public func mio_take_error ( ) -> UnsafeMutableRawPointer? {
    MCWasm.takeError( ).map { MCWasm.buffer( $0 ) }
}

#endif
