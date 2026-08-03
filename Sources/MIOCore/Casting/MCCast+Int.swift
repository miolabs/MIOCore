//
//  MCCast+Int.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension MCCast {

    /// Strips the fractional part of a numeric string so `Int("3.9")` becomes `Int("3")`.
    private static func removingStringFloat(_ string: String) -> String {
        let components = string.components(separatedBy: ".")
        if components.count > 0 { return components[0] }
        return "0"
    }

    /// Converts any value to an `Int` when it can.
    ///
    /// Accepts any integer type, `Bool` (`true` → `1`), `Character`, `Float`/`Double`, `Decimal`/
    /// `NSDecimalNumber`, `NSNumber`, or a numeric `String`. Fractional strings are truncated at the
    /// decimal point (`"3.9"` → `3`), and decimals are rounded to scale `0`. Unconvertible input falls
    /// back to `def`. This never throws.
    ///
    /// ```swift
    /// MCCast.int("42")            // 42   (string coerced)
    /// MCCast.int("3.9")           // 3    (truncated at the dot)
    /// MCCast.int(true)            // 1
    /// MCCast.int(nil, default: 0) // 0    (default used)
    /// ```
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Int`, or `def` when conversion is not possible.
    public static func int(_ value: Any?, `default` def: Int? = nil) -> Int? {
        if let asString = value as? String { return Int(removingStringFloat(asString)) ?? def }
        if let asBool = value as? Bool { return Int(asBool ? 1 : 0) }
        if let asChar = value as? Character { return Int(String(asChar)) }
        if let asInt = value as? Int8 { return Int(asInt) }
        if let asInt = value as? Int16 { return Int(asInt) }
        if let asInt = value as? Int32 { return Int(asInt) }
        if let asInt = value as? Int64 { return Int(asInt) }
        if let asInt = value as? Int { return asInt }
        if let asFloat = value as? Float { return Int(asFloat) }
        if let asDouble = value as? Double { return Int(asDouble) }
        if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).intValue }
        if let asNumber = value as? NSNumber { return asNumber.intValue }
        if let asDecimal = value as? Decimal { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).intValue }

        return def
    }

    /// Converts any value to an `Int8`, clamping out-of-range integers.
    ///
    /// Behaves like ``int(_:default:)`` but targets 8-bit width: out-of-range integer inputs are
    /// clamped (not truncated to garbage) rather than trapping. Unconvertible input falls back to
    /// `def`. This never throws.
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Int8`, or `def` when conversion is not possible.
    public static func int8(_ value: Any?, `default` def: Int8? = nil) -> Int8? {
        if let asString = value as? String { return Int8(removingStringFloat(asString)) }
        if let asBool = value as? Bool { return Int8(asBool ? 1 : 0) }
        if let asChar = value as? Character { return Int8(String(asChar)) }
        if let asInt = value as? Int8 { return asInt }
        if let asInt = value as? Int16 { return Int8(clamping: asInt) }
        if let asInt = value as? Int32 { return Int8(clamping: asInt) }
        if let asInt = value as? Int64 { return Int8(clamping: asInt) }
        if let asInt = value as? Int { return Int8(clamping: asInt) }
        if let asFloat = value as? Float { return Int8(asFloat) }
        if let asDouble = value as? Double { return Int8(asDouble) }
        if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).int8Value }
        if let asNumber = value as? NSNumber { return asNumber.int8Value }
        if let asDecimal = value as? Decimal { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).int8Value }

        return def
    }

    /// Converts any value to an `Int16`, clamping out-of-range integers.
    ///
    /// The 16-bit counterpart of ``int(_:default:)``; see it for the accepted input types.
    /// Unconvertible input falls back to `def`. This never throws.
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Int16`, or `def` when conversion is not possible.
    public static func int16(_ value: Any?, `default` def: Int16? = nil) -> Int16? {
        if let asString = value as? String { return Int16(removingStringFloat(asString)) }
        if let asBool = value as? Bool { return Int16(asBool ? 1 : 0) }
        if let asChar = value as? Character { return Int16(String(asChar)) }
        if let asInt = value as? Int8 { return Int16(asInt) }
        if let asInt = value as? Int16 { return asInt }
        if let asInt = value as? Int32 { return Int16(clamping: asInt) }
        if let asInt = value as? Int64 { return Int16(clamping: asInt) }
        if let asInt = value as? Int { return Int16(clamping: asInt) }
        if let asFloat = value as? Float { return Int16(asFloat) }
        if let asDouble = value as? Double { return Int16(asDouble) }
        if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).int16Value }
        if let asNumber = value as? NSNumber { return asNumber.int16Value }
        if let asDecimal = value as? Decimal { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).int16Value }

        return def
    }

    /// Converts any value to a `UInt16`, clamping out-of-range integers.
    ///
    /// The unsigned 16-bit counterpart of ``int(_:default:)``; see it for the accepted input types.
    /// Unconvertible input falls back to `def`. This never throws.
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `UInt16`, or `def` when conversion is not possible.
    public static func uint16(_ value: Any?, `default` def: UInt16? = nil) -> UInt16? {
        if let asString = value as? String { return UInt16(removingStringFloat(asString)) }
        if let asBool = value as? Bool { return UInt16(asBool ? 1 : 0) }
        if let asChar = value as? Character { return UInt16(String(asChar)) }
        if let asInt = value as? UInt8 { return UInt16(asInt) }
        if let asInt = value as? UInt16 { return asInt }
        if let asInt = value as? UInt32 { return UInt16(clamping: asInt) }
        if let asInt = value as? UInt64 { return UInt16(clamping: asInt) }
        if let asInt = value as? UInt { return UInt16(clamping: asInt) }
        if let asInt = value as? Int { return UInt16(clamping: asInt) }
        if let asFloat = value as? Float { return UInt16(asFloat) }
        if let asDouble = value as? Double { return UInt16(asDouble) }
        if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).uint16Value }
        if let asNumber = value as? NSNumber { return asNumber.uint16Value }
        if let asDecimal = value as? Decimal { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).uint16Value }

        return def
    }

    /// Converts any value to an `Int32`, clamping out-of-range integers.
    ///
    /// The 32-bit counterpart of ``int(_:default:)``; see it for the accepted input types.
    /// Unconvertible input falls back to `def`. This never throws.
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Int32`, or `def` when conversion is not possible.
    public static func int32(_ value: Any?, `default` def: Int32? = nil) -> Int32? {
        if let asString = value as? String { return Int32(removingStringFloat(asString)) }
        if let asBool = value as? Bool { return Int32(asBool ? 1 : 0) }
        if let asChar = value as? Character { return Int32(String(asChar)) }
        if let asInt = value as? Int8 { return Int32(asInt) }
        if let asInt = value as? Int16 { return Int32(asInt) }
        if let asInt = value as? Int32 { return asInt }
        if let asInt = value as? Int64 { return Int32(clamping: asInt) }
        if let asInt = value as? Int { return Int32(clamping: asInt) }
        if let asFloat = value as? Float { return Int32(asFloat) }
        if let asDouble = value as? Double { return Int32(asDouble) }
        if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).int32Value }
        if let asNumber = value as? NSNumber { return asNumber.int32Value }
        if let asDecimal = value as? Decimal { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).int32Value }

        return def
    }

    /// Converts any value to a `UInt32`, clamping out-of-range integers.
    ///
    /// The unsigned 32-bit counterpart of ``int(_:default:)``; see it for the accepted input types.
    /// Unconvertible input falls back to `def`. This never throws.
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `UInt32`, or `def` when conversion is not possible.
    public static func uint32(_ value: Any?, `default` def: UInt32? = nil) -> UInt32? {
        if let asString = value as? String { return UInt32(removingStringFloat(asString)) }
        if let asBool = value as? Bool { return UInt32(asBool ? 1 : 0) }
        if let asChar = value as? Character { return UInt32(String(asChar)) }
        if let asInt = value as? UInt8 { return UInt32(asInt) }
        if let asInt = value as? UInt16 { return UInt32(asInt) }
        if let asInt = value as? UInt32 { return asInt }
        if let asInt = value as? UInt64 { return UInt32(clamping: asInt) }
        if let asInt = value as? UInt { return UInt32(clamping: asInt) }
        if let asFloat = value as? Float { return UInt32(asFloat) }
        if let asDouble = value as? Double { return UInt32(asDouble) }
        if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).uint32Value }
        if let asNumber = value as? NSNumber { return asNumber.uint32Value }
        if let asDecimal = value as? Decimal { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).uint32Value }

        return def
    }

    /// Converts any value to an `Int64` when it can.
    ///
    /// The 64-bit counterpart of ``int(_:default:)``; see it for the accepted input types.
    /// Unconvertible input falls back to `def`. This never throws.
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `Int64`, or `def` when conversion is not possible.
    public static func int64(_ value: Any?, `default` def: Int64? = nil) -> Int64? {
        if let asString = value as? String { return Int64(removingStringFloat(asString)) }
        if let asBool = value as? Bool { return Int64(asBool ? 1 : 0) }
        if let asInt = value as? Int8 { return Int64(asInt) }
        if let asInt = value as? Int16 { return Int64(asInt) }
        if let asInt = value as? Int32 { return Int64(asInt) }
        if let asInt = value as? Int64 { return asInt }
        if let asInt = value as? Int { return Int64(asInt) }
        if let asFloat = value as? Float { return Int64(asFloat) }
        if let asDouble = value as? Double { return Int64(asDouble) }
        if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).int64Value }
        if let asNumber = value as? NSNumber { return asNumber.int64Value }
        if let asDecimal = value as? Decimal { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).int64Value }

        return def
    }

    /// Converts any value to a `UInt64` when it can.
    ///
    /// The unsigned 64-bit counterpart of ``int(_:default:)``; see it for the accepted input types.
    /// Unconvertible input falls back to `def`. This never throws.
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert.
    ///   - def: The value returned when `value` is unconvertible. Defaults to `nil`.
    /// - Returns: The coerced `UInt64`, or `def` when conversion is not possible.
    public static func uint64(_ value: Any?, `default` def: UInt64? = nil) -> UInt64? {
        if let asString = value as? String { return UInt64(removingStringFloat(asString)) }
        if let asBool = value as? Bool { return UInt64(asBool ? 1 : 0) }
        if let asInt = value as? Int8 { return UInt64(asInt) }
        if let asInt = value as? Int16 { return UInt64(asInt) }
        if let asInt = value as? Int32 { return UInt64(asInt) }
        if let asInt = value as? Int64 { return UInt64(asInt) }
        if let asInt = value as? UInt { return UInt64(asInt) }
        if let asInt = value as? UInt8 { return UInt64(asInt) }
        if let asInt = value as? UInt16 { return UInt64(asInt) }
        if let asInt = value as? UInt32 { return UInt64(asInt) }
        if let asInt = value as? UInt64 { return asInt }
        if let asInt = value as? UInt { return UInt64(asInt) }
        if let asFloat = value as? Float { return UInt64(asFloat) }
        if let asDouble = value as? Double { return UInt64(asDouble) }
        if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).uint64Value }
        if let asNumber = value as? NSNumber { return asNumber.uint64Value }
        if let asDecimal = value as? Decimal { return NSDecimalNumber(decimal: asDecimal.roundingBy(scale: 0, roundingMode: .plain)).uint64Value }

        return def
    }

    /// Reports whether a dynamic value is *already* one of Swift's signed integer types.
    ///
    /// Returns `true` only for a live `Int8`/`Int16`/`Int32`/`Int64`/`Int` instance, it does **not**
    /// attempt coercion, so a numeric `String` or `NSNumber` returns `false`. Used to fast-path values
    /// that need no conversion (for example in ``decimal(_:default:)``).
    ///
    /// - Parameter value: The dynamic value to test.
    /// - Returns: `true` if `value` is a signed integer type; otherwise `false`.
    public static func isInt(_ value: Any?) -> Bool {
        if value is Int8 { return true }
        if value is Int16 { return true }
        if value is Int32 { return true }
        if value is Int64 { return true }
        if value is Int { return true }
        return false
    }
}
