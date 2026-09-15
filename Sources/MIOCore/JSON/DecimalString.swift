//
//  DecimalString.swift
//  MIOCore
//
//  Created by Javier Segura Perez on 1/9/26.
//

import Foundation

/// Encodes and decodes a `Decimal` as a JSON string.
///
/// `JSONEncoder`/`JSONDecoder` round-trip bare JSON numbers through `Double`, which corrupts
/// currency values. Wrapping a `Decimal` property with `@DecimalString` keeps the value exact by
/// putting it on the wire as a string. Decoding also tolerates a JSON number, routing it through
/// ``MCCast/decimal(_:default:)`` so the `Double` noise is scrubbed.
///
/// ```swift
/// struct Payload : Codable {
///     @DecimalString var amount: Decimal
/// }
/// ```
@propertyWrapper
public struct DecimalString : Codable, Sendable
{
    public var wrappedValue: Decimal

    public init( wrappedValue: Decimal ) { self.wrappedValue = wrappedValue }

    public init( from decoder: Decoder ) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode( String.self ), let value = MCCast.decimal( str ) {
            wrappedValue = value
        }
        else if let dbl = try? container.decode( Double.self ), let value = MCCast.decimal( dbl ) {
            wrappedValue = value
        }
        else {
            throw DecodingError.dataCorruptedError( in: container, debugDescription: "Invalid decimal value" )
        }
    }

    public func encode( to encoder: Encoder ) throws {
        var container = encoder.singleValueContainer()
        try container.encode( "\(wrappedValue)" )
    }
}
