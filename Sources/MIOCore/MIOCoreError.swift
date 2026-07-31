//
//  File.swift
//  
//
//  Created by David Trallero on 28/05/2021.
//

import Foundation


/// The shared error type thrown across MIOCore's coercion and parameter helpers.
///
/// Each case captures the enclosing `#function` by default, so the rendered
/// ``errorDescription`` points at where the failure originated. It conforms to `LocalizedError`,
/// giving a human-readable message.
public enum MIOCoreError: Error
{
    /// A general failure carrying a message (e.g. an unparseable date). Captures the call site.
    case general( _ msg: String, functionName: String = #function)
    /// A required parameter was missing or of the wrong type. Thrown by the `MIOCoreParam…` helpers.
    case invalidParameter(_ parameterName: String, functionName: String = #function)
    /// A parameter was present but its value was not accepted (e.g. failed a whitelist check).
    case invalidParameterValue(_ parameterName: String, _ value: String = #function)
}


extension MIOCoreError: LocalizedError {
    /// A human-readable description prefixed with `[MIOCoreError]` and the originating function.
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
