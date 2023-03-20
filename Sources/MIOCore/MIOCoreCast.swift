//
//  MIOCoreCast.swift
//  
//
//  Created by David Trallero on 23/10/2020.
//

import Foundation


public func MIOCoreBoolValue ( _ value: Any?, _ def_value: Bool? = nil) -> Bool? {
    if value == nil { return def_value }
        
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

public func MIOCoreDecimalValue ( _ value: Any?, _ def_value: Decimal? ) -> Decimal? {
    if value == nil { return def_value }
    
    if let asString  = value! as? String     { return Decimal( string: asString ) ?? def_value }
    if let asDecimal = value! as? Decimal    { return asDecimal }
    if let asDouble  = value! as? Double     { return Decimal( floatLiteral: asDouble ) }
    if let asInt     = MIOCoreIntValue( value ) { return Decimal( integerLiteral: asInt ) }

    return def_value
}


