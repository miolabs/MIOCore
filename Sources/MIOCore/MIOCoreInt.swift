//
//  File.swift
//  
//
//  Created by Javier Segura Perez on 19/3/21.
//

import Foundation


public func MIOCoreIntValue ( _ value: Any?, _ def_value: Int? = nil ) -> Int? {
    if let asString = value as? String { return Int(asString) }
    if let asBool   = value as? Bool   { return Int(asBool ? 1 : 0 ) }
    if let asInt    = value as? Int8   { return Int(asInt) }
    if let asInt    = value as? Int16  { return Int(asInt) }
    if let asInt    = value as? Int32  { return Int(asInt) }
    if let asInt    = value as? Int64  { return Int(asInt) }
    if let asInt    = value as? Int    { return     asInt  }
    if let asDouble = value as? Double { return Int(asDouble) }

    return def_value
}


public func MIOCoreIsIntValue ( _ value: Any? ) -> Bool {
    if MIOCoreIntValue(value) == nil { return false }
    return true
}
