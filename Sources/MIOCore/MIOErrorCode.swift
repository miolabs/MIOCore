//
//  File.swift
//  
//
//  Created by David Trallero on 24/09/2020.
//

import Foundation

public protocol MIOErrorCode: Error
{
    var code: Int { get }
}

// ..000: last 3 hex digits for errors
// XX000: the rest is used for layer/libraries. Higher number means high layer
//        Example:
//          network  0x100
//          coredate 0x200
//          sync     0x300
public let E_CORE             = 0x01000
         , E_DB               = 0x03000
         , E_DB_MYSQL         = 0x04000
         , E_DB_POSTGRES      = 0x05000
         , E_PERSISTENT_STORE = 0x08000
         , E_CORE_DATA        = 0x09000
