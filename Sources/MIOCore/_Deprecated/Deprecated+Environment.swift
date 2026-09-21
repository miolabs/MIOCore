//
//  Deprecated+Environment.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous environment-lookup signatures. Use MCEnvironment instead. Kept as forwards so downstream keeps building.
//

import Foundation

@available(*, deprecated, renamed: "MCEnvironment.variable(_:)")
public func MCEnvironmentVar(_ name: String) -> String? {
    MCEnvironment.variable(name)
}
