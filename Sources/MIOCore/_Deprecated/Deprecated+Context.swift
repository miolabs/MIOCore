//
//  Deprecated+Context.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous context signatures. Use MCContext / MCUserDefault instead. Kept as forwards so downstream keeps building.
//

import Foundation

@available(*, deprecated, renamed: "MCContext")
public typealias MIOCoreContext = MCContext

@available(*, deprecated, renamed: "MCContextProtocol")
public typealias MIOCoreContextProtocol = MCContextProtocol

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)

@available(*, deprecated, renamed: "MCUserDefault")
public typealias ContextUserDefaultVar = MCUserDefault

@available(*, deprecated, renamed: "MCUserDefaultOptional")
public typealias ContextUserDefaultOptionalVar = MCUserDefaultOptional

#endif
