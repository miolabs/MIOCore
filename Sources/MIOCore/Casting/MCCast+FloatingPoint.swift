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
        if let asInt = value! as? Int8 { return Double(asInt) }
        if let asInt = value! as? Int16 { return Double(asInt) }
        if let asInt = value! as? Int32 { return Double(asInt) }
        if let asInt = value! as? Int64 { return Double(asInt) }
        if let asInt = value! as? Int { return Double(asInt) }
        if let asDecimal = value! as? Decimal { return NSDecimalNumber(decimal: asDecimal).doubleValue }
        if let asFloat = value! as? Float { return Double(asFloat) }
        if let asDouble = value! as? Double { return asDouble }
        if let asString = value! as? String {
            let integer = Double(asString)
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
        if let asInt = value! as? Int8 { return Float(asInt) }
        if let asInt = value! as? Int16 { return Float(asInt) }
        if let asInt = value! as? Int32 { return Float(asInt) }
        if let asInt = value! as? Int64 { return Float(asInt) }
        if let asInt = value! as? Int { return Float(asInt) }
        if let asDecimal = value! as? Decimal { return NSDecimalNumber(decimal: asDecimal).floatValue }
        if let asFloat = value! as? Float { return asFloat }
        if let asDouble = value! as? Double { return Float(asDouble) }
        if let asString = value! as? String {
            let integer = Float(asString)
            if integer != nil { return integer! }
        }

        return def
    }
}
