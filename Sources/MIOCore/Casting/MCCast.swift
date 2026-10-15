//
//  MCCast.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// Lenient coercion of `Any?` into concrete Swift types.
///
/// Input from JSON bodies, DB rows, and HTTP parameters arrives as `Any?`, where `value as? Int`
/// fails the moment a number arrives as `"42"`. Each method coerces the value and falls back to
/// `default` instead of throwing. ``uuid(_:default:optional:)`` is the exception, it throws.
///
/// Each cast has a strict `xValue` twin (``intValue(_:default:error:)``, ``boolValue(_:default:error:)``,
/// ...) that returns a non-optional and throws `error`, or ``MCCastError/invalidValue(_:type:)`` when
/// `error` is `nil`, once the coercion (and `default`) yields nothing.
///
/// ```swift
/// MCCast.int("42")                         // 42
/// MCCast.int(raw, default: 0)              // 0 when raw is nil/unconvertible
/// try MCCast.intValue(raw)                 // throws MCCastError when raw is nil/unconvertible
/// try MCCast.intValue(raw, error: MyErr.x) // throws MyErr.x instead
/// ```
public enum MCCast {}

extension MCCast {
    /// Unwraps a coercion result for the throwing `xValue` variants, throwing `error` (or
    /// ``MCCastError/invalidValue(_:type:)``) when the coercion produced `nil`.
    static func _required<T>(_ result: T?, _ value: Any?, _ error: Error?) throws -> T {
        if let result { return result }
        throw error ?? MCCastError.invalidValue(value, type: T.self)
    }
}
