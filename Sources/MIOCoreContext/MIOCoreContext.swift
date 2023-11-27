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
    open var globals: [ String: Any ] = [:]

    public init ( _ values: [String:Any] = [:] ) {
        globals = values
    }
}
    

