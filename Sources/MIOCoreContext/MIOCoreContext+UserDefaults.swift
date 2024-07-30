//
//  MIOCoreContext+UserDefaults.swift
//
//
//  Created by Javier Segura Perez on 22/11/23.
//

#if !os(Linux)

import Foundation

// #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

@propertyWrapper
public struct ContextUserDefaultVar<Value>
{
    let key:String
    let default_value:Value
    
    public var wrappedValue: Value {
        get { return UserDefaults.standard.value( forKey: key ) as? Value ?? default_value }
        set { UserDefaults.standard.setValue( newValue, forKey: key ) }
    }
    
    public init( key:String, defaultValue:Value ) {
        self.key = key
        self.default_value = defaultValue
    }
}

@propertyWrapper
public struct ContextUserDefaultOptionalVar<Value>
{
    let key:String
    let default_value:Value?
    
    public var wrappedValue: Value? {
        get { return UserDefaults.standard.value( forKey: key ) as? Value ?? default_value }
        set { UserDefaults.standard.setValue( newValue, forKey: key ) }
    }
    
    public init( key:String, defaultValue:Value? = nil ) {
        self.key = key
        self.default_value = defaultValue
    }
}

#endif
