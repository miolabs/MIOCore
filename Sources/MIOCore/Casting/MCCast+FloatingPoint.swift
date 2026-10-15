//
//  MCCast+FloatingPoint.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension MCCast {

    /// Converts any value to a `Double` when it can.
    ///
    /// Accepts any integer type, `Decimal`, `Float`, `Double`, or a numeric `String`. Anything else
    /// falls back to `def`. This never throws.
    ///
    /// > For currency use ``decimal(_:default:)`` instead, binary floating point cannot represent
    /// > decimal money exactly.
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Double`, or `def` when conversion is not possible.
    public static func double(_ value: Any?, `default` def: Double? = nil) -> Double? {
        if let as_int = value as? Int8 { return Double(as_int) }
        if let as_int = value as? Int16 { return Double(as_int) }
        if let as_int = value as? Int32 { return Double(as_int) }
        if let as_int = value as? Int64 { return Double(as_int) }
        if let as_int = value as? Int { return Double(as_int) }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal).doubleValue }
        if let as_float = value as? Float { return Double(as_float) }
        if let as_double = value as? Double { return as_double }
        if let as_string = value as? String {
            let integer = Double(as_string)
            if integer != nil { return integer! }
        }

        return def
    }

    /// Converts any value to a `Float` when it can.
    ///
    /// The single-precision counterpart of ``double(_:default:)``: accepts any integer type,
    /// `Decimal`, `Float`, `Double`, or a numeric `String`, and falls back to `def` otherwise.
    /// This never throws.
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Float`, or `def` when conversion is not possible.
    public static func float(_ value: Any?, `default` def: Float? = nil) -> Float? {
        if let as_int = value as? Int8 { return Float(as_int) }
        if let as_int = value as? Int16 { return Float(as_int) }
        if let as_int = value as? Int32 { return Float(as_int) }
        if let as_int = value as? Int64 { return Float(as_int) }
        if let as_int = value as? Int { return Float(as_int) }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal).floatValue }
        if let as_float = value as? Float { return as_float }
        if let as_double = value as? Double { return Float(as_double) }
        if let as_string = value as? String {
            let integer = Float(as_string)
            if integer != nil { return integer! }
        }

        return def
    }

    /// Converts any value to `Double`, throwing when it cannot.
    ///
    /// The strict counterpart of ``double(_:default:)``: same coercion rules, but an unconvertible value
    /// (with no `def`) throws `error`, or ``MCCastError/invalidValue(_:type:)`` when `error` is `nil`.
    public static func doubleValue(_ value: Any?, `default` def: Double? = nil, error: Error? = nil) throws -> Double {
        try _required(double(value, default: def), value, error)
    }

    /// Converts any value to `Float`, throwing when it cannot.
    ///
    /// The strict counterpart of ``float(_:default:)``: same coercion rules, but an unconvertible value
    /// (with no `def`) throws `error`, or ``MCCastError/invalidValue(_:type:)`` when `error` is `nil`.
    public static func floatValue(_ value: Any?, `default` def: Float? = nil, error: Error? = nil) throws -> Float {
        try _required(float(value, default: def), value, error)
    }
}
