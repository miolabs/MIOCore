//
//  MCParam+Typed.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension MCParam {

    /// Reads a dictionary value and coerces it to `Int`, or returns `def` when the key is absent.
    ///
    /// Built on ``decode(_:from:_:)`` + ``MCCast/int(_:default:)``: a present-but-unconvertible value
    /// throws; a missing key yields `def`.
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - def: The value returned when the key is missing. Defaults to `nil`.
    /// - Returns: The coerced `Int`, or `def`.
    /// - Throws: ``MCError/invalidParameter(_:functionName:)`` if a present value cannot be converted.
    public static func int(_ key: String, from dict: [String: Any?], `default` def: Int? = nil) throws -> Int? {
        try decode(key, from: dict) { arg in
            let value: Any? = arg as Any?

            if value == nil { return def }

            if let converted = MCCast.int(value) {
                return converted
            }

            throw MCError.invalidParameter("\(value!) could not be converted to Int")
        }
    }

    /// Reads a dictionary value and coerces it to `Int16`, or returns `def` when the key is absent.
    ///
    /// The 16-bit sibling of ``int(_:from:default:)``; a present-but-unconvertible value throws.
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - def: The value returned when the key is missing. Defaults to `nil`.
    /// - Returns: The coerced `Int16`, or `def`.
    /// - Throws: ``MCError/invalidParameter(_:functionName:)`` if a present value cannot be converted.
    public static func int16(_ key: String, from dict: [String: Any?], `default` def: Int16? = nil) throws -> Int16? {
        try decode(key, from: dict) { arg in
            let value: Any? = arg as Any?

            if value == nil { return def }

            if let converted = MCCast.int16(value) {
                return converted
            }

            throw MCError.invalidParameter("\(value!) could not be converted to Int")
        }
    }

    /// Reads a dictionary value and coerces it to `Int32`, or returns `def` when the key is absent.
    ///
    /// The 32-bit sibling of ``int(_:from:default:)``; a present-but-unconvertible value throws.
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - def: The value returned when the key is missing. Defaults to `nil`.
    /// - Returns: The coerced `Int32`, or `def`.
    /// - Throws: ``MCError/invalidParameter(_:functionName:)`` if a present value cannot be converted.
    public static func int32(_ key: String, from dict: [String: Any?], `default` def: Int32? = nil) throws -> Int32? {
        try decode(key, from: dict) { arg in
            let value: Any? = arg as Any?

            if value == nil { return def }

            if let converted = MCCast.int32(value) {
                return converted
            }

            throw MCError.invalidParameter("\(value!) could not be converted to Int")
        }
    }

    /// Reads a dictionary value and coerces it to `Int64`, or returns `def` when the key is absent.
    ///
    /// The 64-bit sibling of ``int(_:from:default:)``; a present-but-unconvertible value throws.
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - def: The value returned when the key is missing. Defaults to `nil`.
    /// - Returns: The coerced `Int64`, or `def`.
    /// - Throws: ``MCError/invalidParameter(_:functionName:)`` if a present value cannot be converted.
    public static func int64(_ key: String, from dict: [String: Any?], `default` def: Int64? = nil) throws -> Int64? {
        try decode(key, from: dict) { arg in
            let value: Any? = arg as Any?

            if value == nil { return def }

            if let converted = MCCast.int64(value) {
                return converted
            }

            throw MCError.invalidParameter("\(value!) could not be converted to Int")
        }
    }

    /// Reads a dictionary value and coerces it to a money-safe `Decimal`, or returns `def`.
    ///
    /// Built on ``decode(_:from:_:)`` + ``MCCast/decimal(_:default:)``, so a string like `"25.00"`
    /// becomes an exact `Decimal`, the correct helper for currency amounts in request bodies.
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - def: The value returned when the key is missing or unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Decimal`, or `def`.
    public static func decimal(_ key: String, from dict: [String: Any?], `default` def: Decimal? = nil) throws -> Decimal? {
        try decode(key, from: dict) { value in MCCast.decimal(value, default: def) }
    }

    /// Reads a dictionary value and coerces it to `Bool`, or returns `def`.
    ///
    /// Built on ``decode(_:from:_:)`` + ``MCCast/bool(_:default:)``, so `"true"`/`"yes"`/`"1"` and
    /// integer `1` all read as `true`.
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - def: The value returned when the key is missing or unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Bool`, or `def`.
    public static func bool(_ key: String, from dict: [String: Any?], `default` def: Bool? = nil) throws -> Bool? {
        try decode(key, from: dict) { value in MCCast.bool(value, default: def) }
    }
}
