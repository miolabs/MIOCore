//
//  MIOCoreCast.swift
//  
//
//  Created by David Trallero on 23/10/2020.
//

import Foundation


/// Converts any value to a `Bool` when it can.
///
/// Accepts a real `Bool`, the case-insensitive strings `"true"`, `"yes"`, or `"1"`, or any integer
/// (where `1` is `true`). Anything else, including `nil` and `NSNull`, falls back to `def_value`.
/// This never throws.
///
/// ```swift
/// MIOCoreBoolValue("yes")        // true
/// MIOCoreBoolValue(1)            // true
/// MIOCoreBoolValue("nope")       // nil
/// MIOCoreBoolValue(nil, false)   // false  (default used)
/// ```
///
/// - Parameters:
///   - value: The dynamic value to convert (typically from a JSON body or DB row).
///   - def_value: The value returned when `value` is `nil`/`NSNull`/unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Bool`, or `def_value` when conversion is not possible.
public func MIOCoreBoolValue ( _ value: Any?, _ def_value: Bool? = nil) -> Bool?
{
    if value == nil || value is NSNull { return def_value }
    if let as_bool = value as? Bool { return as_bool }
        
    if let as_string = ( value as? String )?.lowercased() {
        return (as_string == "true" || as_string == "yes" || as_string == "1")
    }
    
    if let as_int = value as? Int   { return as_int == 1 }
    if let as_int = value as? Int8  { return as_int == 1 }
    if let as_int = value as? Int16 { return as_int == 1 }
    if let as_int = value as? Int32 { return as_int == 1 }
    if let as_int = value as? Int64 { return as_int == 1 }
    
    return def_value
}

/// Converts any value to a `Double` when it can.
///
/// Accepts any integer type, `Decimal`, `Float`, `Double`, or a numeric `String`. Anything else
/// falls back to `def_value`. This never throws.
///
/// > For currency use ``MCDecimalValue(_:_:)`` instead, binary floating point cannot represent
/// > decimal money exactly.
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Double`, or `def_value` when conversion is not possible.
public func MIOCoreDoubleValue ( _ value: Any?, _ def_value: Double? = nil ) -> Double? {
    if let asInt     = value! as? Int8   { return Double(asInt) }
    if let asInt     = value! as? Int16  { return Double(asInt) }
    if let asInt     = value! as? Int32  { return Double(asInt) }
    if let asInt     = value! as? Int64  { return Double(asInt) }
    if let asInt     = value! as? Int    { return Double(asInt) }
    if let asDecimal = value! as? Decimal{ return NSDecimalNumber(decimal: asDecimal).doubleValue }
    if let asFloat   = value! as? Float  { return Double(asFloat) }
    if let asDouble  = value! as? Double { return asDouble }
    if let asString  = value! as? String {
        let integer  = Double(asString)
        if integer != nil { return integer! }
    }
    
    return def_value
}

/// Converts any value to a `Float` when it can.
///
/// The single-precision counterpart of ``MIOCoreDoubleValue(_:_:)``: accepts any integer type,
/// `Decimal`, `Float`, `Double`, or a numeric `String`, and falls back to `def_value` otherwise.
/// This never throws.
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Float`, or `def_value` when conversion is not possible.
public func MIOCoreFloatValue ( _ value: Any?, _ def_value: Float? = nil ) -> Float? {
    
    if let asInt     = value! as? Int8   { return Float(asInt) }
    if let asInt     = value! as? Int16  { return Float(asInt) }
    if let asInt     = value! as? Int32  { return Float(asInt) }
    if let asInt     = value! as? Int64  { return Float(asInt) }
    if let asInt     = value! as? Int    { return Float(asInt) }
    if let asDecimal = value! as? Decimal{ return NSDecimalNumber(decimal: asDecimal).floatValue }
    if let asFloat   = value! as? Float  { return asFloat }
    if let asDouble  = value! as? Double { return Float(asDouble) }
    if let asString  = value! as? String {
        let integer  = Float(asString)
        if integer != nil { return integer! }
    }
 
    return def_value
}
