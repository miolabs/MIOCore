//
//  MIOCoreCast.swift
//  
//
//  Created by David Trallero on 23/10/2020.
//

import Foundation


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
