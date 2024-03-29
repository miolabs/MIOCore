//
//
//  MIOCoreContext.swift
//
//
//  Created by Javier Segura Perez on 16/11/23.
//

import Foundation

public protocol MIOCoreContextProtocol
{
    var globals: [ String: Any ] { get }
}

open class MIOCoreContext : NSObject, MIOCoreContextProtocol
{
    open var globals: [ String: Any ] = [:]

    public init ( _ values: [String:Any] = [:] ) {
        globals = values
    }
}
