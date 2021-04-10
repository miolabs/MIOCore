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

public func MIOCoreIntValue ( _ value: Any?, _ def_value: Int? = nil ) -> Int? {
    if let asString = value as? String { return Int(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return Int(asBool ? 1 : 0 ) }
    if let asInt    = value as? Int8   { return Int(asInt) }
    if let asInt    = value as? Int16  { return Int(asInt) }
    if let asInt    = value as? Int32  { return Int(asInt) }
    if let asInt    = value as? Int64  { return Int(asInt) }
    if let asInt    = value as? Int    { return     asInt  }
    if let asDouble = value as? Double { return Int(asDouble) }

    return def_value
}


public func MIOCoreInt8Value ( _ value: Any?, _ def_value: Int8? = nil ) -> Int8? {
    if let asString = value as? String { return Int8(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return Int8(asBool ? 1 : 0 ) }
    if let asInt    = value as? Int8   { return      asInt  }
    if let asInt    = value as? Int16  { return Int8(asInt) }
    if let asInt    = value as? Int32  { return Int8(asInt) }
    if let asInt    = value as? Int64  { return Int8(asInt) }
    if let asInt    = value as? Int    { return Int8(asInt) }
    if let asDouble = value as? Double { return Int8(asDouble) }

    return def_value
}

public func MIOCoreInt16Value ( _ value: Any?, _ def_value: Int16? = nil ) -> Int16? {
    if let asString = value as? String { return Int16(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return Int16(asBool ? 1 : 0 ) }
    if let asInt    = value as? Int8   { return Int16(asInt) }
    if let asInt    = value as? Int16  { return       asInt  }
    if let asInt    = value as? Int32  { return Int16(asInt) }
    if let asInt    = value as? Int64  { return Int16(asInt) }
    if let asInt    = value as? Int    { return Int16(asInt) }
    if let asDouble = value as? Double { return Int16(asDouble) }

    return def_value
}

public func MIOCoreInt32Value ( _ value: Any?, _ def_value: Int32? = nil ) -> Int32? {
    if let asString = value as? String { return Int32(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return Int32(asBool ? 1 : 0 ) }
    if let asInt    = value as? Int8   { return Int32(asInt) }
    if let asInt    = value as? Int16  { return Int32(asInt) }
    if let asInt    = value as? Int32  { return       asInt  }
    if let asInt    = value as? Int64  { return Int32(asInt) }
    if let asInt    = value as? Int    { return Int32(asInt) }
    if let asDouble = value as? Double { return Int32(asDouble) }

    return def_value
}


public func MIOCoreInt64Value ( _ value: Any?, _ def_value: Int64? = nil ) -> Int64? {
    if let asString = value as? String { return Int64(MIOCoreIntRemovingStringFloatValue(asString)) }
    if let asBool   = value as? Bool   { return Int64(asBool ? 1 : 0 ) }
    if let asInt    = value as? Int8   { return Int64(asInt) }
    if let asInt    = value as? Int16  { return Int64(asInt) }
    if let asInt    = value as? Int32  { return Int64(asInt) }
    if let asInt    = value as? Int64  { return       asInt  }
    if let asInt    = value as? Int    { return Int64(asInt) }
    if let asDouble = value as? Double { return Int64(asDouble) }

    return def_value
}


public func MIOCoreIsIntValue ( _ value: Any? ) -> Bool {
    if MIOCoreIntValue(value) == nil { return false }
    return true
}
