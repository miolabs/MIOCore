//
//  Environment.swift
//  MIOCore
//
//  Created by Javier Segura Perez on 6/2/25.
//

import Foundation

public func MCEnvironmentVar(_ name: String) -> String? {
    // Use ProcessInfo to avoid holding raw C pointers from getenv (safer on Linux).
    let env = ProcessInfo.processInfo.environment
    guard let value = env[ name ], value.isEmpty == false else { return nil }
    return value
}
