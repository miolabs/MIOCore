//
//  MIOCoreUUID.swift
//  
//
//  Created by Javier Segura Perez on 26/6/23.
//

import Foundation

public func MIOCoreUUIDValue ( _ value: Any?, _ def_value: UUID? = nil, optional: Bool = true ) throws -> UUID?
{
    var ret:UUID? = nil
    if let str = value as? String { ret = UUID( uuidString: str ) }
    if let uuid = value as? UUID { ret = uuid }
    
    if ret == nil && optional == false {
        throw MIOCoreError.invalidParameterValue( "\(String(describing: value))" )
    }
    
    return ret ?? def_value
}
