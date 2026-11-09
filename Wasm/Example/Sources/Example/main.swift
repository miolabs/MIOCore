// A WASI reactor: the host calls the exports below after `_initialize`.
#if os(WASI)
import Foundation
import MIOCoreWasm

@_expose(wasm, "example_echo")
@_cdecl("example_echo")
public func example_echo ( _ text: UnsafeRawPointer?, _ length: Int32 ) -> UnsafeMutableRawPointer {
    MCWasm.buffer( MCWasm.string( text, length ).uppercased( ) )
}

struct SumIn: Decodable { let values: [Decimal] }
struct SumOut: Encodable { let sum: Decimal; let count: Int }

@_expose(wasm, "example_sum")
@_cdecl("example_sum")
public func example_sum ( _ json: UnsafeRawPointer?, _ length: Int32 ) -> UnsafeMutableRawPointer {
    guard let input = try? MCWasm.json( SumIn.self, json, length ) else { return MCWasm.buffer( "null" ) }
    return MCWasm.buffer( json: SumOut( sum: input.values.reduce( 0, + ), count: input.values.count ) )
}

@_expose(wasm, "example_optional")
@_cdecl("example_optional")
public func example_optional ( _ text: UnsafeRawPointer?, _ length: Int32 ) -> UnsafeMutableRawPointer {
    MCWasm.buffer( MCWasm.optionalString( text, length ).map { "some:" + $0 } ?? "none" )
}

@_expose(wasm, "example_reverse")
@_cdecl("example_reverse")
public func example_reverse ( _ bytes: UnsafeRawPointer?, _ length: Int32 ) -> UnsafeMutableRawPointer {
    MCWasm.buffer( Data( MCWasm.data( bytes, length ).reversed( ) ) )
}

@_expose(wasm, "example_add")
@_cdecl("example_add")
public func example_add ( _ a: Int32, _ b: Int32, _ negate: Int32 ) -> Int32 {
    negate != 0 ? -( a + b ) : a + b
}
#endif
