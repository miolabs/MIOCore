//
//  File.swift
//  
//
//  Created by David Trallero on 23/10/2020.
//

import Foundation


public func MIOCoreIntValue ( _ value: Any?, _ def_value: Int? = nil ) -> Int? {
    if let asString = value as? String { return Int(asString) }
    if let asInt    = value as? Int8   { return Int(asInt) }
    if let asInt    = value as? Int16  { return Int(asInt) }
    if let asInt    = value as? Int32  { return Int(asInt) }
    if let asInt    = value as? Int64  { return Int(asInt) }
    if let asInt    = value as? Int    { return     asInt  }
    if let asDouble = value as? Double { return Int(asDouble) }
    
    return def_value
}


public func MIOCoreDecimalValue ( _ value: Any?, _ def_value: Decimal? ) -> Decimal? {
    if value == nil { return def_value }
    
    if let asString  = value! as? String     { return Decimal(string: asString) }
    if let asDecimal = value! as? Decimal    { return asDecimal }
    if let asDouble  = value! as? Double     { return Decimal(floatLiteral: asDouble) }
    if let asInt     = MIOCoreIntValue( value ) { return Decimal(integerLiteral: asInt) }

    return def_value
}


