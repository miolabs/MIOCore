//
//  MIOCoreParam.swift
//
//
//  Created by David Trallero on 24/07/2020.
//


import Foundation

public func MIOCoreParam<T> ( _ dict: [String:Any?], _ name: String ) throws -> T {
    if let ret = dict[ name ] as? T {
        return ret
    }
    
    throw MIOCoreError.invalidParameter( name )
}


public func MIOCoreParam<T> ( _ dict: [String:Any?], _ name: String, _ whitelist_value: @escaping (_ value: Any) throws -> T ) throws -> T {
    let ret = dict[ name ]
    
    if ret != nil {
        return try whitelist_value( ret as Any )
    }
    
    throw MIOCoreError.invalidParameter( name )
}


public func MIOCoreSafeParam<T> ( _ dict: [String:Any?], _ name: String, _ whitelist_value: @escaping (_ value: Any?) throws -> T ) throws -> T {
    return try whitelist_value( dict[ name ] ?? nil )
}


public func optional_param<T> ( _ dict: [String:Any?], _ name: String, _ def_value: @escaping () throws -> T  ) throws -> T
{
    if let ret = dict[ name ] as? T {
        return ret
    }
    
    return try def_value( )
}


public func MIOCoreParamInt32 ( _ dict: [String:Any?], _ name: String, _ def_value: Int32? = nil ) throws -> Int32? {
  return try MIOCoreSafeParam( dict, name ){ arg in
    let value: Any? = arg as Any?

    if value == nil { return def_value } // throw DLDBError.invalidParameter( name ) }
        
    if let converted = MIOCoreInt32Value( value, nil ) {
        return converted
    }
    
    throw MIOCoreError.invalidParameter( "\(value!) could not be converted to Int" )
  }
}

public func MIOCoreParamInt16 ( _ dict: [String:Any?], _ name: String, _ def_value: Int16? = nil ) throws -> Int16? {
  return try MIOCoreSafeParam( dict, name ){ arg in
    let value: Any? = arg as Any?

    if value == nil { return def_value } // throw DLDBError.invalidParameter( name ) }
        
    if let converted = MIOCoreInt16Value( value, nil ) {
        return converted
    }
    
    throw MIOCoreError.invalidParameter( "\(value!) could not be converted to Int" )
  }
}


public func MIOCoreParamInt64 ( _ dict: [String:Any?], _ name: String, _ def_value: Int64? = nil ) throws -> Int64? {
  return try MIOCoreSafeParam( dict, name ){ arg in
    let value: Any? = arg as Any?

    if value == nil { return def_value } // throw DLDBError.invalidParameter( name ) }
        
    if let converted = MIOCoreInt64Value( value, nil ) {
        return converted
    }
    
    throw MIOCoreError.invalidParameter( "\(value!) could not be converted to Int" )
  }
}


public func MIOCoreParamInt ( _ dict: [String:Any?], _ name: String, _ def_value: Int? = nil ) throws -> Int? {
  return try MIOCoreSafeParam( dict, name ){ arg in
    let value: Any? = arg as Any?

    if value == nil { return def_value } // throw DLDBError.invalidParameter( name ) }
        
    if let converted = MIOCoreIntValue( value, nil ) {
        return converted
    }
    
    throw MIOCoreError.invalidParameter( "\(value!) could not be converted to Int" )
  }
}


public func MIOCoreParamDecimal ( _ dict: [String:Any?], _ name: String, _ def_value: Decimal? = nil ) throws -> Decimal? {
    return try MIOCoreSafeParam( dict, name ){ value in MIOCoreDecimalValue( value, def_value ) }
}

public func MIOCoreParamBool ( _ dict: [String:Any?], _ name: String, _ def_value: Bool? = nil ) throws -> Bool? {
    return try MIOCoreSafeParam( dict, name ){ value in MIOCoreBoolValue( value, def_value ) }
}


public func MIOCoreParamSelect<T: Equatable> ( _ dict: [String:Any?], _ name: String, _ accepted_values: [T] ) throws -> T {
  let value: T = try MIOCoreParam( dict, name )
  
  if !accepted_values.contains( value ) {
    throw MIOCoreError.invalidParameterValue( name, value )
  }
  
  return value
}

