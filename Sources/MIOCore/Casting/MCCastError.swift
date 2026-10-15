//
//  MCCastError.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// The error thrown by the strict `MCCast.xValue` variants when no custom error is supplied.
public enum MCCastError: Error {
    /// `value` could not be converted to `type` and no default was available.
    case invalidValue(_ value: Any?, type: Any.Type)
}

extension MCCastError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidValue(let value, let type):
            return "[MCCastError] Cannot convert \(value.map { "\"\($0)\"" } ?? "nil") to \(type)."
        }
    }
}
