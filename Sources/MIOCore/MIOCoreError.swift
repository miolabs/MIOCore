//
//  File.swift
//  
//
//  Created by David Trallero on 28/05/2021.
//

import Foundation

public enum MIOCoreError: Error
{
    case general( _ msg: String, functionName: String = #function)
}


extension MIOCoreError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .general(msg, functionName):
            return "[MIOCoreError] \(functionName): \(msg)."
        }
    }
}
