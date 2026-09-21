//
//  MCCast+Bool.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension MCCast {

    /// Converts any value to a `Bool` when it can.
    ///
    /// Accepts a real `Bool`, the case-insensitive strings `"true"`, `"yes"`, or `"1"`, or any integer
    /// (where `1` is `true`). Anything else, including `nil` and `NSNull`, falls back to `def`.
    /// This never throws.
    ///
    /// ```swift
    /// MCCast.bool("yes")             // true
    /// MCCast.bool(1)                 // true
    /// MCCast.bool(0)                 // false
    /// MCCast.bool("nope")            // nil
    /// MCCast.bool(nil, default: false) // false  (default used)
    /// ```
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert (typically from a JSON body or DB row).
    ///   - def: The value returned when `value` is `nil`/`NSNull`/unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Bool`, or `def` when conversion is not possible.
    public static func bool(_ value: Any?, `default` def: Bool? = nil) -> Bool? {
        if value == nil || value is NSNull { return def }
        if let as_bool = value as? Bool { return as_bool }

        if let as_string = (value as? String)?.lowercased() {
            return (as_string == "true" || as_string == "yes" || as_string == "1")
        }

        if let as_int = value as? Int { return as_int == 1 }
        if let as_int = value as? Int8 { return as_int == 1 }
        if let as_int = value as? Int16 { return as_int == 1 }
        if let as_int = value as? Int32 { return as_int == 1 }
        if let as_int = value as? Int64 { return as_int == 1 }

        return def
    }
}
