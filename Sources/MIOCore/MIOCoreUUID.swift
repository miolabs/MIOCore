//
//  MIOCoreUUID.swift
//  
//
//  Created by Javier Segura Perez on 26/6/23.
//

import Foundation

public func MIOCoreUUIDValue ( _ value: Any?, _ def_value: UUID? = nil, optional: Bool = true ) throws -> UUID?
{
    if let str = value as? String { return UUID( uuidString: str ) }
    if let uuid = value as? UUID { return uuid }
    
    if optional == false {
        throw MIOCoreError.invalidParameterValue( "\(String(describing: value))" )
    }
    
    return def_value
}
