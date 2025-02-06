//
//  Environment.swift
//  MIOCore
//
//  Created by Javier Segura Perez on 6/2/25.
//

import Foundation

public func MCEnvironmentVar(_ name: String) -> String? {
    guard let rawValue = getenv(name) else { return nil }
    return String(utf8String: rawValue)
}
