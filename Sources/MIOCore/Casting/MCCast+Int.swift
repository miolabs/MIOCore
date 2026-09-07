//
//  MCCast+Int.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension MCCast {

    /// Strips the fractional part of a numeric string so `Int("3.9")` becomes `Int("3")`.
    private static func _removing_string_float(_ string: String) -> String {
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
        if let as_string = value as? String { return Int(_removing_string_float(as_string)) ?? def }
        if let as_bool = value as? Bool { return Int(as_bool ? 1 : 0) }
        if let as_char = value as? Character { return Int(String(as_char)) }
        if let as_int = value as? Int8 { return Int(as_int) }
        if let as_int = value as? Int16 { return Int(as_int) }
        if let as_int = value as? Int32 { return Int(as_int) }
        if let as_int = value as? Int64 { return Int(as_int) }
        if let as_int = value as? Int { return as_int }
        if let as_float = value as? Float { return Int(as_float) }
        if let as_double = value as? Double { return Int(as_double) }
        if let as_decimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).intValue }
        if let as_number = value as? NSNumber { return as_number.intValue }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).intValue }

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
        if let as_string = value as? String { return Int8(_removing_string_float(as_string)) }
        if let as_bool = value as? Bool { return Int8(as_bool ? 1 : 0) }
        if let as_char = value as? Character { return Int8(String(as_char)) }
        if let as_int = value as? Int8 { return as_int }
        if let as_int = value as? Int16 { return Int8(clamping: as_int) }
        if let as_int = value as? Int32 { return Int8(clamping: as_int) }
        if let as_int = value as? Int64 { return Int8(clamping: as_int) }
        if let as_int = value as? Int { return Int8(clamping: as_int) }
        if let as_float = value as? Float { return Int8(as_float) }
        if let as_double = value as? Double { return Int8(as_double) }
        if let as_decimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).int8Value }
        if let as_number = value as? NSNumber { return as_number.int8Value }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).int8Value }

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
        if let as_string = value as? String { return Int16(_removing_string_float(as_string)) }
        if let as_bool = value as? Bool { return Int16(as_bool ? 1 : 0) }
        if let as_char = value as? Character { return Int16(String(as_char)) }
        if let as_int = value as? Int8 { return Int16(as_int) }
        if let as_int = value as? Int16 { return as_int }
        if let as_int = value as? Int32 { return Int16(clamping: as_int) }
        if let as_int = value as? Int64 { return Int16(clamping: as_int) }
        if let as_int = value as? Int { return Int16(clamping: as_int) }
        if let as_float = value as? Float { return Int16(as_float) }
        if let as_double = value as? Double { return Int16(as_double) }
        if let as_decimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).int16Value }
        if let as_number = value as? NSNumber { return as_number.int16Value }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).int16Value }

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
        if let as_string = value as? String { return UInt16(_removing_string_float(as_string)) }
        if let as_bool = value as? Bool { return UInt16(as_bool ? 1 : 0) }
        if let as_char = value as? Character { return UInt16(String(as_char)) }
        if let as_int = value as? UInt8 { return UInt16(as_int) }
        if let as_int = value as? UInt16 { return as_int }
        if let as_int = value as? UInt32 { return UInt16(clamping: as_int) }
        if let as_int = value as? UInt64 { return UInt16(clamping: as_int) }
        if let as_int = value as? UInt { return UInt16(clamping: as_int) }
        if let as_int = value as? Int { return UInt16(clamping: as_int) }
        if let as_float = value as? Float { return UInt16(as_float) }
        if let as_double = value as? Double { return UInt16(as_double) }
        if let as_decimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).uint16Value }
        if let as_number = value as? NSNumber { return as_number.uint16Value }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).uint16Value }

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
        if let as_string = value as? String { return Int32(_removing_string_float(as_string)) }
        if let as_bool = value as? Bool { return Int32(as_bool ? 1 : 0) }
        if let as_char = value as? Character { return Int32(String(as_char)) }
        if let as_int = value as? Int8 { return Int32(as_int) }
        if let as_int = value as? Int16 { return Int32(as_int) }
        if let as_int = value as? Int32 { return as_int }
        if let as_int = value as? Int64 { return Int32(clamping: as_int) }
        if let as_int = value as? Int { return Int32(clamping: as_int) }
        if let as_float = value as? Float { return Int32(as_float) }
        if let as_double = value as? Double { return Int32(as_double) }
        if let as_decimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).int32Value }
        if let as_number = value as? NSNumber { return as_number.int32Value }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).int32Value }

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
        if let as_string = value as? String { return UInt32(_removing_string_float(as_string)) }
        if let as_bool = value as? Bool { return UInt32(as_bool ? 1 : 0) }
        if let as_char = value as? Character { return UInt32(String(as_char)) }
        if let as_int = value as? UInt8 { return UInt32(as_int) }
        if let as_int = value as? UInt16 { return UInt32(as_int) }
        if let as_int = value as? UInt32 { return as_int }
        if let as_int = value as? UInt64 { return UInt32(clamping: as_int) }
        if let as_int = value as? UInt { return UInt32(clamping: as_int) }
        if let as_float = value as? Float { return UInt32(as_float) }
        if let as_double = value as? Double { return UInt32(as_double) }
        if let as_decimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).uint32Value }
        if let as_number = value as? NSNumber { return as_number.uint32Value }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).uint32Value }

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
        if let as_string = value as? String { return Int64(_removing_string_float(as_string)) }
        if let as_bool = value as? Bool { return Int64(as_bool ? 1 : 0) }
        if let as_int = value as? Int8 { return Int64(as_int) }
        if let as_int = value as? Int16 { return Int64(as_int) }
        if let as_int = value as? Int32 { return Int64(as_int) }
        if let as_int = value as? Int64 { return as_int }
        if let as_int = value as? Int { return Int64(as_int) }
        if let as_float = value as? Float { return Int64(as_float) }
        if let as_double = value as? Double { return Int64(as_double) }
        if let as_decimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).int64Value }
        if let as_number = value as? NSNumber { return as_number.int64Value }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).int64Value }

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
        if let as_string = value as? String { return UInt64(_removing_string_float(as_string)) }
        if let as_bool = value as? Bool { return UInt64(as_bool ? 1 : 0) }
        if let as_int = value as? Int8 { return UInt64(as_int) }
        if let as_int = value as? Int16 { return UInt64(as_int) }
        if let as_int = value as? Int32 { return UInt64(as_int) }
        if let as_int = value as? Int64 { return UInt64(as_int) }
        if let as_int = value as? UInt { return UInt64(as_int) }
        if let as_int = value as? UInt8 { return UInt64(as_int) }
        if let as_int = value as? UInt16 { return UInt64(as_int) }
        if let as_int = value as? UInt32 { return UInt64(as_int) }
        if let as_int = value as? UInt64 { return as_int }
        if let as_int = value as? UInt { return UInt64(as_int) }
        if let as_float = value as? Float { return UInt64(as_float) }
        if let as_double = value as? Double { return UInt64(as_double) }
        if let as_decimal = value as? NSDecimalNumber { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).uint64Value }
        if let as_number = value as? NSNumber { return as_number.uint64Value }
        if let as_decimal = value as? Decimal { return NSDecimalNumber(decimal: as_decimal.roundingBy(scale: 0, roundingMode: .plain)).uint64Value }

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
