//
//  MCEnvironment.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// Reads process environment variables.
public enum MCEnvironment {

    /// Reads a process environment variable, treating empty values as absent.
    ///
    /// Uses `ProcessInfo` rather than raw `getenv`, which is safer on Linux (no dangling C pointers).
    /// Returns `nil` when the variable is unset *or* set to the empty string.
    ///
    /// ```swift
    /// let port = MCEnvironment.variable("PORT") ?? "8080"
    /// ```
    ///
    /// - Parameter name: The environment variable name.
    /// - Returns: The non-empty value, or `nil`.
    public static func variable(_ name: String) -> String? {
        let env = ProcessInfo.processInfo.environment
        guard let value = env[name], value.isEmpty == false else { return nil }
        return value
    }
}
