//
//  MCParam.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// Reads typed values out of a dynamic `[String: Any?]` (a decoded JSON body, a query dictionary).
///
/// The family splits into two groups along two independent axes:
///
/// - **Key handling.** ``require(_:from:)`` throws when the key is missing; ``optional(_:from:default:)``
///   and the typed getters fall back to a `default`.
/// - **Value handling.** The generic accessors (``require(_:from:)`` / ``optional(_:from:default:)``)
///   do a strict `as? T` with no coercion; the typed getters (``int(_:from:default:)``,
///   ``decimal(_:from:default:)``, ``bool(_:from:default:)``, ...) coerce messy input (`"42"` -> `42`)
///   and throw only on present-but-garbage.
///
/// So `optional("x", from: body, default: 0)` returns `0` for a present `"7"` (a `String` fails
/// `as? Int`), while `int("x", from: body, default: 0)` returns `7`. Use the typed getters for
/// untrusted scalar wire values, and `optional` for values already in the right Swift type.
///
/// ```swift
/// let id:   String = try MCParam.require("accountID", from: body)
/// let cur:  String = try MCParam.select("currency", from: body, oneOf: ["EUR", "USD"])
/// let page: Int    = try MCParam.optional("page", from: body, default: 1)
/// let count: Int?  = try MCParam.int("count", from: body, default: 0)
/// ```
public enum MCParam {

    /// Reads a required, typed value, throwing when the key is missing or not a `T`.
    ///
    /// Strict `as? T`: no coercion, so a `"7"` string does not satisfy `T == Int`.
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    /// - Returns: The value cast to `T`.
    /// - Throws: ``MCError/invalidParameter(_:functionName:)`` if the key is missing or not a `T`.
    public static func require<T>(_ key: String, from dict: [String: Any?]) throws -> T {
        if let ret = dict[key] as? T {
            return ret
        }

        throw MCError.invalidParameter(key)
    }

    /// Reads a required value and validates/transforms it through a closure.
    ///
    /// The key must be present (a missing key throws before `validate` runs); the raw value, possibly
    /// `NSNull`, is passed to `validate`, whose thrown errors propagate.
    ///
    /// ```swift
    /// let n: Int = try MCParam.require("count", from: body) { raw in
    ///     guard let i = MCCast.int(raw), i >= 0 else { throw MCError.invalidParameterValue("count", "\(raw)") }
    ///     return i
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - validate: A closure that validates or transforms the raw value into `T`.
    /// - Returns: The value returned by `validate`.
    /// - Throws: ``MCError/invalidParameter(_:functionName:)`` if the key is missing, or any
    ///   error thrown by `validate`.
    public static func require<T>(_ key: String, from dict: [String: Any?], validate: (_ value: Any) throws -> T) throws -> T {
        let ret = dict[key]

        if ret != nil {
            return try validate(ret as Any)
        }

        throw MCError.invalidParameter(key)
    }

    /// Reads an optional, typed value, computing a `default` when the key is absent or the wrong type.
    ///
    /// Strict `as? T` (no coercion); the `default` is an `@autoclosure`, so it is only evaluated when
    /// needed.
    ///
    /// ```swift
    /// let page: Int = try MCParam.optional("page", from: body, default: 1)   // 1 when "page" is missing
    /// ```
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - def: The fallback produced when the key is missing or not a `T`.
    /// - Returns: The stored value cast to `T`, or the `default`.
    /// - Throws: Any error thrown while producing the `default`.
    public static func optional<T>(_ key: String, from dict: [String: Any?], `default` def: @autoclosure () throws -> T) throws -> T {
        if let ret = dict[key] as? T {
            return ret
        }

        return try def()
    }

    /// Reads a required value and validates it against a fixed whitelist (enum-like validation).
    ///
    /// Reads `key` via ``require(_:from:)`` and rejects anything not in `accepted`. Useful for
    /// constrained fields such as a currency or status code.
    ///
    /// ```swift
    /// let currency: String = try MCParam.select("currency", from: body, oneOf: ["EUR", "USD"])
    /// ```
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - accepted: The allowed values; the read value must be `==` to one of them.
    /// - Returns: The validated value.
    /// - Throws: ``MCError/invalidParameter(_:functionName:)`` if the key is missing, or
    ///   ``MCError/invalidParameterValue(_:_:)`` if the value is not in `accepted`.
    public static func select<T: Equatable>(_ key: String, from dict: [String: Any?], oneOf accepted: [T]) throws -> T {
        let value: T = try require(key, from: dict)

        if !accepted.contains(value) {
            throw MCError.invalidParameterValue(key, "\(value)")
        }

        return value
    }

    /// Passes a value (present or not) through a closure that decides how to handle absence.
    ///
    /// A missing key is **not** an error: the closure always runs and receives `nil` when the key is
    /// absent, so it owns the default-vs-throw decision. This is the building block the typed getters
    /// (``int(_:from:default:)``, ``bool(_:from:default:)``, ...) are built on.
    ///
    /// - Parameters:
    ///   - key: The key to read.
    ///   - dict: The source dictionary.
    ///   - transform: A closure that maps the optional raw value (or `nil`) into `T`.
    /// - Returns: The value returned by `transform`.
    /// - Throws: Any error thrown by `transform`.
    public static func decode<T>(_ key: String, from dict: [String: Any?], _ transform: (_ value: Any?) throws -> T) throws -> T {
        try transform(dict[key] ?? nil)
    }
}
