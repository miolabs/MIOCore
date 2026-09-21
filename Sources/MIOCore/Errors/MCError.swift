//
//  MCError.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// The shared error type thrown by MIOCore's coercion and parameter helpers.
public enum MCError: Error {
    /// A general failure carrying a message (e.g. an unparseable date). Captures the call site.
    case general(_ msg: String, functionName: String = #function)
    /// A required parameter was missing or of the wrong type. Thrown by the `MCParam` helpers.
    case invalidParameter(_ parameterName: String, functionName: String = #function)
    /// A parameter was present but its value was not accepted (e.g. failed a whitelist check).
    case invalidParameterValue(_ parameterName: String, _ value: String = #function)
}

extension MCError: LocalizedError {
    /// A human-readable description prefixed with `[MCError]` and the originating function.
    public var errorDescription: String? {
        switch self {
        case .general(let msg, let functionName):
            return "[MCError] \(functionName): \(msg)."
        case .invalidParameter(let parameterName, let functionName):
            return "[MCError] \(functionName) Invalid parameter \"\(parameterName)\"."
        case .invalidParameterValue(let parameterName, let value):
            return "[MCError] \(parameterName) has invalid value \"\(value)\"."
        }
    }
}
