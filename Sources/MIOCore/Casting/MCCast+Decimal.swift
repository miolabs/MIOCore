//
//  MCCast+Decimal.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension MCCast {

    /// Converts any value to a money-safe `Decimal` when it can.
    ///
    /// Accepts `NSDecimalNumber`, `Decimal`, any integer, or a numeric `String`, and falls back to
    /// `def` otherwise. A `Double` is routed through its shortest round-trip string rather than
    /// `Decimal(_: Double)`, so binary-floating-point noise does not leak into the mantissa
    /// (`-3182.7` stays `-3182.7`, not `-3182.6999999999...`). This never throws.
    ///
    /// ```swift
    /// MCCast.decimal("19.99")         // 19.99 (exact)
    /// MCCast.decimal(-3182.7)         // -3182.7 (no binary noise)
    /// MCCast.decimal(3)               // 3
    /// MCCast.decimal(nil, default: 0) // 0     (default used)
    /// ```
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is `nil`/unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Decimal`, or `def` when conversion is not possible.
    public static func decimal(_ value: Any?, `default` def: Decimal? = nil) -> Decimal? {
        if value == nil { return def }

        if let as_decimal = value! as? NSDecimalNumber { return as_decimal.decimalValue }
        if let as_double = value! as? Double {
            // Decimal(floatLiteral:) carries the Double's binary noise into the mantissa
            // (-3182.7 -> -3182.6999999999999791, >64 bits). The shortest round-trip
            // string representation yields a clean, compact Decimal.
            if as_double.isFinite == false { return Decimal.nan }
            return Decimal(string: "\(as_double)") ?? Decimal(as_double)
        }
        if let as_decimal = value! as? Decimal { return as_decimal }
        if MCCast.isInt(value) { return Decimal(integerLiteral: MCCast.int(value)!) }
        if let as_string = value! as? String { return Decimal(string: as_string) ?? def }

        return def
    }
}
