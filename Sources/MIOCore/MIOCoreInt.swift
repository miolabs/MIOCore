//
//  File.swift
//  
//
//  Created by Javier Segura Perez on 19/3/21.
//

import Foundation


func MIOCoreIntRemovingStringFloatValue(_ string:String) -> String {
    let components = string.components(separatedBy: ".")
    if components.count > 0 { return components [0] }
    return "0"
}
/// Converts any value to an `Int` when it can.
///
/// Accepts any integer type, `Bool` (`true` → `1`), `Character`, `Float`/`Double`, `Decimal`/
/// `NSDecimalNumber`, `NSNumber`, or a numeric `String`. Fractional strings are truncated at the
/// decimal point (`"3.9"` → `3`), and decimals are rounded to scale `0`. Unconvertible input falls
/// back to `def_value`. This never throws.
///
/// ```swift
/// MIOCoreIntValue("42")     // 42   (string coerced)
/// MIOCoreIntValue("3.9")    // 3    (truncated at the dot)
/// MIOCoreIntValue(true)     // 1
/// MIOCoreIntValue(nil, 0)   // 0    (default used)
/// ```
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Int`, or `def_value` when conversion is not possible.
public func MIOCoreIntValue ( _ value: Any?, _ def_value: Int? = nil ) -> Int? {
    if let asString = value as? String { return Int( MIOCoreIntRemovingStringFloatValue( asString ) ) ?? def_value }
    if let asBool   = value as? Bool   { return Int(asBool ? 1 : 0 ) }
    if let asChar   = value as? Character { return Int(String(asChar)) }
    if let asInt    = value as? Int8   { return Int(asInt) }
    if let asInt    = value as? Int16  { return Int(asInt) }
    if let asInt    = value as? Int32  { return Int(asInt) }
    if let asInt    = value as? Int64  { return Int(asInt) }
    if let asInt    = value as? Int    { return     asInt  }
    if let asFloat  = value as? Float  { return Int(asFloat) }
    if let asDouble = value as? Double { return Int(asDouble) }
    if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).intValue }
    if let asNumber = value as? NSNumber { return asNumber.intValue }
    if let asDecimal = value as? Decimal { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).intValue }

    return def_value
}


/// Converts any value to an `Int8`, clamping out-of-range integers.
///
/// Behaves like ``MIOCoreIntValue(_:_:)`` but targets 8-bit width: out-of-range integer inputs are
/// clamped (not truncated to garbage) rather than trapping. Unconvertible input falls back to
/// `def_value`. This never throws.
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Int8`, or `def_value` when conversion is not possible.
public func MIOCoreInt8Value ( _ value: Any?, _ def_value: Int8? = nil ) -> Int8? {
    if let asString = value as? String { return Int8(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return Int8(asBool ? 1 : 0 ) }
    if let asChar   = value as? Character { return Int8(String(asChar)) }
    if let asInt    = value as? Int8   { return      asInt  }
    if let asInt    = value as? Int16  { return Int8( clamping: asInt ) }
    if let asInt    = value as? Int32  { return Int8( clamping: asInt ) }
    if let asInt    = value as? Int64  { return Int8( clamping: asInt ) }
    if let asInt    = value as? Int    { return Int8( clamping: asInt ) }
    if let asFloat  = value as? Float  { return Int8(asFloat) }
    if let asDouble = value as? Double { return Int8(asDouble) }
    if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).int8Value }
    if let asNumber = value as? NSNumber { return asNumber.int8Value }
    if let asDecimal = value as? Decimal { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).int8Value }

    return def_value
}

/// Converts any value to an `Int16`, clamping out-of-range integers.
///
/// The 16-bit counterpart of ``MIOCoreIntValue(_:_:)``; see it for the accepted input types.
/// Unconvertible input falls back to `def_value`. This never throws.
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Int16`, or `def_value` when conversion is not possible.
public func MIOCoreInt16Value ( _ value: Any?, _ def_value: Int16? = nil ) -> Int16? {
    if let asString = value as? String { return Int16(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return Int16(asBool ? 1 : 0 ) }
    if let asChar   = value as? Character { return Int16(String(asChar)) }
    if let asInt    = value as? Int8   { return Int16(asInt) }
    if let asInt    = value as? Int16  { return       asInt  }
    if let asInt    = value as? Int32 { return Int16( clamping: asInt ) }
    if let asInt    = value as? Int64 { return Int16( clamping: asInt ) }
    if let asInt    = value as? Int   { return Int16( clamping: asInt ) }
    if let asFloat  = value as? Float  { return Int16( asFloat ) }
    if let asDouble = value as? Double { return Int16( asDouble ) }
    if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).int16Value }
    if let asNumber = value as? NSNumber { return asNumber.int16Value }
    if let asDecimal = value as? Decimal { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).int16Value }

    return def_value
}

/// Converts any value to a `UInt16`, clamping out-of-range integers.
///
/// The unsigned 16-bit counterpart of ``MIOCoreIntValue(_:_:)``; see it for the accepted input
/// types. Unconvertible input falls back to `def_value`. This never throws.
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `UInt16`, or `def_value` when conversion is not possible.
public func MCUInt16Value ( _ value: Any?, _ def_value: UInt16? = nil ) -> UInt16? {
    if let asString = value as? String { return UInt16(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return UInt16(asBool ? 1 : 0 ) }
    if let asChar   = value as? Character { return UInt16(String(asChar)) }
    if let asInt    = value as? UInt8   { return UInt16(asInt) }
    if let asInt    = value as? UInt16  { return       asInt  }
    if let asInt    = value as? UInt32 { return UInt16( clamping: asInt ) }
    if let asInt    = value as? UInt64 { return UInt16( clamping: asInt ) }
    if let asInt    = value as? UInt   { return UInt16( clamping: asInt ) }
    if let asInt    = value as? Int   { return UInt16( clamping: asInt ) }
    if let asFloat  = value as? Float  { return UInt16( asFloat ) }
    if let asDouble = value as? Double { return UInt16( asDouble ) }
    if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).uint16Value }
    if let asNumber = value as? NSNumber { return asNumber.uint16Value }
    if let asDecimal = value as? Decimal { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).uint16Value }

    return def_value
}


/// Converts any value to an `Int32`, clamping out-of-range integers.
///
/// The 32-bit counterpart of ``MIOCoreIntValue(_:_:)``; see it for the accepted input types.
/// Unconvertible input falls back to `def_value`. This never throws.
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Int32`, or `def_value` when conversion is not possible.
public func MIOCoreInt32Value ( _ value: Any?, _ def_value: Int32? = nil ) -> Int32? {
    if let asString = value as? String { return Int32(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return Int32(asBool ? 1 : 0 ) }
    if let asChar   = value as? Character { return Int32(String(asChar)) }
    if let asInt    = value as? Int8   { return Int32(asInt) }
    if let asInt    = value as? Int16  { return Int32(asInt) }
    if let asInt    = value as? Int32  { return       asInt  }
    if let asInt    = value as? Int64  { return Int32( clamping: asInt ) }
    if let asInt    = value as? Int    { return Int32( clamping: asInt ) }
    if let asFloat  = value as? Float  { return Int32(asFloat) }
    if let asDouble = value as? Double { return Int32(asDouble) }
    if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).int32Value }
    if let asNumber = value as? NSNumber { return asNumber.int32Value }
    if let asDecimal = value as? Decimal { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).int32Value }

    return def_value
}


/// Converts any value to a `UInt32`, clamping out-of-range integers.
///
/// The unsigned 32-bit counterpart of ``MIOCoreIntValue(_:_:)``; see it for the accepted input
/// types. Unconvertible input falls back to `def_value`. This never throws.
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `UInt32`, or `def_value` when conversion is not possible.
public func MIOCoreUInt32Value ( _ value: Any?, _ def_value: UInt32? = nil ) -> UInt32? {
    if let asString = value as? String { return UInt32(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return UInt32(asBool ? 1 : 0 ) }
    if let asChar   = value as? Character { return UInt32(String(asChar)) }
    if let asInt    = value as? UInt8  { return UInt32(asInt) }
    if let asInt    = value as? UInt16 { return UInt32(asInt) }
    if let asInt    = value as? UInt32 { return        asInt  }
    if let asInt    = value as? UInt64 { return UInt32( clamping: asInt) }
    if let asInt    = value as? UInt   { return UInt32( clamping: asInt) }
    if let asFloat  = value as? Float  { return UInt32(asFloat) }
    if let asDouble = value as? Double { return UInt32(asDouble) }
    if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).uint32Value }
    if let asNumber = value as? NSNumber { return asNumber.uint32Value }
    if let asDecimal = value as? Decimal { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).uint32Value }

    return def_value
}


/// Converts any value to an `Int64` when it can.
///
/// The 64-bit counterpart of ``MIOCoreIntValue(_:_:)``; see it for the accepted input types.
/// Unconvertible input falls back to `def_value`. This never throws.
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Int64`, or `def_value` when conversion is not possible.
public func MIOCoreInt64Value ( _ value: Any?, _ def_value: Int64? = nil ) -> Int64? {
    if let asString = value as? String { return Int64(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return Int64(asBool ? 1 : 0 ) }
    if let asInt    = value as? Int8   { return Int64(asInt) }
    if let asInt    = value as? Int16  { return Int64(asInt) }
    if let asInt    = value as? Int32  { return Int64(asInt) }
    if let asInt    = value as? Int64  { return       asInt  }
    if let asInt    = value as? Int    { return Int64(asInt) }
    if let asFloat  = value as? Float  { return Int64(asFloat) }
    if let asDouble = value as? Double { return Int64(asDouble) }
    if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).int64Value }
    if let asNumber = value as? NSNumber { return asNumber.int64Value }
    if let asDecimal = value as? Decimal { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).int64Value }

    return def_value
}

/// Converts any value to a `UInt64` when it can.
///
/// The unsigned 64-bit counterpart of ``MIOCoreIntValue(_:_:)``; see it for the accepted input
/// types. Unconvertible input falls back to `def_value`. This never throws.
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `UInt64`, or `def_value` when conversion is not possible.
public func MIOCoreUInt64Value ( _ value: Any?, _ def_value: UInt64? = nil ) -> UInt64? {
    if let asString = value as? String { return UInt64(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return UInt64(asBool ? 1 : 0 ) }
    if let asInt    = value as? Int8   { return UInt64(asInt) }
    if let asInt    = value as? Int16  { return UInt64(asInt) }
    if let asInt    = value as? Int32  { return UInt64(asInt) }
    if let asInt    = value as? Int64  { return UInt64(asInt) }
    if let asInt    = value as? UInt   { return UInt64(asInt) }
    if let asInt    = value as? UInt8  { return UInt64(asInt) }
    if let asInt    = value as? UInt16 { return UInt64(asInt) }
    if let asInt    = value as? UInt32 { return UInt64(asInt) }
    if let asInt    = value as? UInt64 { return        asInt  }
    if let asInt    = value as? UInt   { return UInt64(asInt) }
    if let asFloat  = value as? Float  { return UInt64(asFloat) }
    if let asDouble = value as? Double { return UInt64(asDouble) }
    if let asDecimal = value as? NSDecimalNumber { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).uint64Value }
    if let asNumber = value as? NSNumber { return asNumber.uint64Value }
    if let asDecimal = value as? Decimal { return NSDecimalNumber( decimal: asDecimal.roundingBy( scale: 0, roundingMode: .plain ) ).uint64Value }

    return def_value
}


/// Reports whether a dynamic value is *already* one of Swift's signed integer types.
///
/// Returns `true` only for a live `Int8`/`Int16`/`Int32`/`Int64`/`Int` instance, it does **not**
/// attempt coercion, so a numeric `String` or `NSNumber` returns `false`. Used to fast-path values
/// that need no conversion (for example in ``MCDecimalValue(_:_:)``).
///
/// - Parameter value: The dynamic value to test.
/// - Returns: `true` if `value` is a signed integer type; otherwise `false`.
public func MIOCoreIsIntValue ( _ value: Any? ) -> Bool {
    if value is Int8  { return true }
    if value is Int16 { return true }
    if value is Int32 { return true }
    if value is Int64 { return true }
    if value is Int   { return true }
    return false
}
