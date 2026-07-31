//
//  MIOCoreParam.swift
//
//
//  Created by David Trallero on 24/07/2020.
//


import Foundation

/// Extracts a required, typed value from a dynamic dictionary.
///
/// The generic result type `T` is inferred from the call site. If the key is missing or its value
/// is not castable to `T`, the call throws ``MIOCoreError/invalidParameter(_:functionName:)`` naming
/// the offending key, so request handlers fail cleanly instead of silently reading `nil`.
///
/// ```swift
/// let body: [String: Any?] = ["accountID": "cafe-central"]
/// let id: String = try MIOCoreParam(body, "accountID")   // "cafe-central"; throws if absent
/// ```
///
/// - Parameters:
///   - dict: The source dictionary (typically a decoded JSON body or query dictionary).
///   - name: The key to read.
/// - Returns: The value cast to `T`.
/// - Throws: ``MIOCoreError/invalidParameter(_:functionName:)`` if the key is missing or the value
///   is not a `T`.
public func MIOCoreParam<T> ( _ dict: [String:Any?], _ name: String ) throws -> T {
    if let ret = dict[ name ] as? T {
        return ret
    }
    
    throw MIOCoreError.invalidParameter( name )
}


/// Extracts a required value and validates/transforms it through a closure.
///
/// Use this when a raw value must be checked or mapped before you trust it (an inline whitelist,
/// a bounds check, a custom decode). The key must be present, a missing key throws
/// ``MIOCoreError/invalidParameter(_:functionName:)`` before the closure runs. When the key exists,
/// its value (possibly `NSNull`) is passed to `whitelist_value`, whose thrown errors propagate.
///
/// ```swift
/// let n: Int = try MIOCoreParam(body, "count") { raw in
///     guard let i = MIOCoreIntValue(raw), i >= 0 else { throw MIOCoreError.invalidParameterValue("count", "\(raw)") }
///     return i
/// }
/// ```
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - whitelist_value: A closure that validates or transforms the raw value into `T`.
/// - Returns: The value returned by `whitelist_value`.
/// - Throws: ``MIOCoreError/invalidParameter(_:functionName:)`` if the key is missing, or any error
///   thrown by `whitelist_value`.
public func MIOCoreParam<T> ( _ dict: [String:Any?], _ name: String, _ whitelist_value: @escaping (_ value: Any) throws -> T ) throws -> T {
    let ret = dict[ name ]
    
    if ret != nil {
        return try whitelist_value( ret as Any )
    }
    
    throw MIOCoreError.invalidParameter( name )
}


/// Passes a value (present or not) through a closure that decides how to handle absence.
///
/// Unlike ``MIOCoreParam(_:_:_:)``, a missing key is **not** an error here: the closure always runs
/// and receives `nil` when the key is absent, so it owns the default-vs-throw decision. This is the
/// building block the typed `MIOCoreParam…` helpers (``MIOCoreParamInt(_:_:_:)``,
/// ``MIOCoreParamBool(_:_:_:)``, …) are built on.
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - whitelist_value: A closure that maps the optional raw value (or `nil`) into `T`.
/// - Returns: The value returned by `whitelist_value`.
/// - Throws: Any error thrown by `whitelist_value`.
public func MIOCoreSafeParam<T> ( _ dict: [String:Any?], _ name: String, _ whitelist_value: @escaping (_ value: Any?) throws -> T ) throws -> T {
    return try whitelist_value( dict[ name ] ?? nil )
}


/// Extracts an optional, typed value, computing a default when the key is absent or the wrong type.
///
/// The default is provided by an `@autoclosure`-style thunk so it is only evaluated when needed.
///
/// ```swift
/// let page: Int = try optional_param(body, "page") { 1 }   // 1 when "page" is missing
/// ```
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - def_value: A closure producing the fallback when the key is missing or not a `T`.
/// - Returns: The stored value cast to `T`, or the result of `def_value`.
/// - Throws: Any error thrown by `def_value`.
public func optional_param<T> ( _ dict: [String:Any?], _ name: String, _ def_value: @escaping () throws -> T  ) throws -> T
{
    if let ret = dict[ name ] as? T {
        return ret
    }
    
    return try def_value( )
}


/// Reads a dictionary value and coerces it to `Int32`, or returns `def_value` when the key is absent.
///
/// Combines ``MIOCoreSafeParam(_:_:_:)`` with ``MIOCoreInt32Value(_:_:)``: a present-but-unconvertible
/// value throws ``MIOCoreError/invalidParameter(_:functionName:)``, while a missing key yields
/// `def_value`.
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - def_value: The value returned when the key is missing. Defaults to `nil`.
/// - Returns: The coerced `Int32`, or `def_value`.
/// - Throws: ``MIOCoreError/invalidParameter(_:functionName:)`` if a present value cannot be converted.
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

/// Reads a dictionary value and coerces it to `Int16`, or returns `def_value` when the key is absent.
///
/// The 16-bit sibling of ``MIOCoreParamInt(_:_:_:)``; a present-but-unconvertible value throws
/// ``MIOCoreError/invalidParameter(_:functionName:)``.
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - def_value: The value returned when the key is missing. Defaults to `nil`.
/// - Returns: The coerced `Int16`, or `def_value`.
/// - Throws: ``MIOCoreError/invalidParameter(_:functionName:)`` if a present value cannot be converted.
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


/// Reads a dictionary value and coerces it to `Int64`, or returns `def_value` when the key is absent.
///
/// The 64-bit sibling of ``MIOCoreParamInt(_:_:_:)``; a present-but-unconvertible value throws
/// ``MIOCoreError/invalidParameter(_:functionName:)``.
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - def_value: The value returned when the key is missing. Defaults to `nil`.
/// - Returns: The coerced `Int64`, or `def_value`.
/// - Throws: ``MIOCoreError/invalidParameter(_:functionName:)`` if a present value cannot be converted.
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


/// Reads a dictionary value and coerces it to `Int`, or returns `def_value` when the key is absent.
///
/// Combines ``MIOCoreSafeParam(_:_:_:)`` with ``MIOCoreIntValue(_:_:)``. A present-but-unconvertible
/// value throws ``MIOCoreError/invalidParameter(_:functionName:)``; a missing key yields `def_value`.
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - def_value: The value returned when the key is missing. Defaults to `nil`.
/// - Returns: The coerced `Int`, or `def_value`.
/// - Throws: ``MIOCoreError/invalidParameter(_:functionName:)`` if a present value cannot be converted.
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


/// Reads a dictionary value and coerces it to a money-safe `Decimal`, or returns `def_value`.
///
/// Combines ``MIOCoreSafeParam(_:_:_:)`` with ``MCDecimalValue(_:_:)``, so a string like `"25.00"`
/// becomes an exact `Decimal`, the correct helper for currency amounts in request bodies.
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - def_value: The value returned when the key is missing or unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Decimal`, or `def_value`.
public func MIOCoreParamDecimal ( _ dict: [String:Any?], _ name: String, _ def_value: Decimal? = nil ) throws -> Decimal? {
    return try MIOCoreSafeParam( dict, name ){ value in MCDecimalValue( value, def_value ) }
}

/// Reads a dictionary value and coerces it to `Bool`, or returns `def_value`.
///
/// Combines ``MIOCoreSafeParam(_:_:_:)`` with ``MIOCoreBoolValue(_:_:)``, so `"true"`/`"yes"`/`"1"`
/// and integer `1` all read as `true`.
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - def_value: The value returned when the key is missing or unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Bool`, or `def_value`.
public func MIOCoreParamBool ( _ dict: [String:Any?], _ name: String, _ def_value: Bool? = nil ) throws -> Bool? {
    return try MIOCoreSafeParam( dict, name ){ value in MIOCoreBoolValue( value, def_value ) }
}


/// Extracts a required value and validates it against a fixed whitelist (enum-like validation).
///
/// Reads `name` via ``MIOCoreParam(_:_:)`` and then rejects anything not in `accepted_values`,
/// throwing ``MIOCoreError/invalidParameterValue(_:_:)``. Useful for constrained fields such as a
/// currency or status code.
///
/// ```swift
/// let currency: String = try MIOCoreParamSelect(body, "currency", ["EUR", "USD"])   // rejects others
/// ```
///
/// - Parameters:
///   - dict: The source dictionary.
///   - name: The key to read.
///   - accepted_values: The allowed values; the read value must be `==` to one of them.
/// - Returns: The validated value.
/// - Throws: ``MIOCoreError/invalidParameter(_:functionName:)`` if the key is missing, or
///   ``MIOCoreError/invalidParameterValue(_:_:)`` if the value is not in `accepted_values`.
public func MIOCoreParamSelect<T: Equatable> ( _ dict: [String:Any?], _ name: String, _ accepted_values: [T] ) throws -> T {
  let value: T = try MIOCoreParam( dict, name )
  
  if !accepted_values.contains( value ) {
    throw MIOCoreError.invalidParameterValue( name, "\(value)" )
  }
  
  return value
}

