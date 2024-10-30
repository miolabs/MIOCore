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
}

open class MIOCoreContext : NSObject, MIOCoreContextProtocol
{
    private let lock = NSLock()
    private var _globals:[ String: Any ]
    
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
        _globals = values
    }
    
    public func setGlobalValue ( _ value: Any, forKey key: String )
    {
        lock.lock()
        defer { lock.unlock() }
        _globals[key] = value
    }
    
    public func removeGlobalValue ( forKey key: String )
    {
        lock.lock()
        defer { lock.unlock() }
        _globals.removeValue( forKey: key )
    }
}
