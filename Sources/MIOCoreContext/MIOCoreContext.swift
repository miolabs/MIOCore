//
//
//  MIOCoreContext.swift
//
//
//  Created by Javier Segura Perez on 16/11/23.
//

import Foundation

//@attached(accessor)
//public macro ContextVar() = #externalMacro( module: "MIOCoreContextMacros", type: "ContextVarMacro" )

public protocol MIOCoreContextProtocol
{
    var globals: [ String: Any ] { get }
    
    func setGlobalValue ( _ value: Any, forKey key: String )
    func removeGlobalValue ( forKey key: String )
    func sendableValues() -> [String:(any Sendable)]
}

open class MIOCoreContext : NSObject, MIOCoreContextProtocol
{
    private let lock = NSLock()
    private var _globals:[ String: Any ] = [:]
    private var _sendable_globals:[ String:(any Sendable)] = [:]
    
    public var globals: [ String: Any ] {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _globals
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _globals = newValue
        }
    }

    public init ( _ values: [String:Any] = [:] ) {
        super.init( )
        for (key, value) in values {
            setGlobalValue( value, forKey: key )
        }
    }
        
    public func setGlobalValue ( _ value: Any, forKey key: String )
    {
        lock.lock()
        defer { lock.unlock() }
        _globals[key] = value
    }
    
    public func setGlobalValue ( _ value: any Sendable, forKey key: String )
    {
        lock.lock()
        defer { lock.unlock() }
        _globals[key] = value
        _sendable_globals[key] = value
    }

    
    public func removeGlobalValue ( forKey key: String )
    {
        lock.lock()
        defer { lock.unlock() }
        _globals.removeValue( forKey: key )
        _sendable_globals.removeValue(forKey: key)
    }
    
    open func sendableValues() -> [String:(any Sendable)] {
        lock.lock()
        defer { lock.unlock() }
        return _sendable_globals
    }
}
