//
//  MIOCoreCast.swift
//  
//
//  Created by David Trallero on 23/10/2020.
//

import Foundation


public func MIOCoreBoolValue ( _ value: Any?, _ def_value: Bool? = nil) -> Bool?
{
    if value == nil { return def_value }
    if value is Bool { return value as? Bool }
        
    if let asString = value as? String {
        let v = asString.lowercased()
        return (v == "true" || v == "yes")
    }
    
    if let asInt = value as? Int   { return asInt == 1 }
    if let asInt = value as? Int8  { return asInt == 1 }
    if let asInt = value as? Int16 { return asInt == 1 }
    if let asInt = value as? Int32 { return asInt == 1 }
    if let asInt = value as? Int64 { return asInt == 1 }
    
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
