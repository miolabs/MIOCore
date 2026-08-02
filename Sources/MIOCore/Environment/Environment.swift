//
//  Environment.swift
//
//  Created by MIO Research Labs on 06/02/2025.
//

import Foundation

/// Reads a process environment variable, treating empty values as absent.
///
/// Uses `ProcessInfo` rather than raw `getenv`, which is safer on Linux (no dangling C pointers).
/// Returns `nil` when the variable is unset *or* set to the empty string.
///
/// ```swift
/// let port = MCEnvironmentVar("PORT") ?? "8080"
/// ```
///
/// - Parameter name: The environment variable name.
/// - Returns: The non-empty value, or `nil`.
public func MCEnvironmentVar(_ name: String) -> String? {
    // Use ProcessInfo to avoid holding raw C pointers from getenv (safer on Linux).
    let env = ProcessInfo.processInfo.environment
    guard let value = env[ name ], value.isEmpty == false else { return nil }
    return value
}
