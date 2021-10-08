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
    case invalidParameter(_ parameterName: String, functionName: String = #function)
    case invalidParameterValue(_ parameterName: String, _ value: Any = #function)
}


extension MIOCoreError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .general(msg, functionName):
            return "[MIOCoreError] \(functionName): \(msg)."
        case let .invalidParameter(parameterName, functionName):
            return "[MIOCoreError] \(functionName) Invalid parameter \"\(parameterName)\"."
        case let .invalidParameterValue(parameterName, value):
            return "[MIOCoreError] \(parameterName) has invalid value \"\(value)\"."
        }
    }
}
