//
//
//  MIOCoreContextMacros.swift
//
//
//  Created by Javier Segura Perez on 16/11/23.
//

import Foundation

@attached(accessor)
public macro ContextVar() = #externalMacro( module: "MIOCoreContextMacros", type: "ContextVarMacro" )

open class MIOCoreContext : NSObject
{
    var _globals: [ String: Any ] = [:]
    public var globals: [ String: Any ]  { get { _globals } }

    public init ( _ values: [String:Any] = [:] ) {
        _globals = values
    }
}
    

