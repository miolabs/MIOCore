//
//  Deprecated+Error.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous error signatures. Use MCError / MCErrorCode instead. Kept as forwards so downstream keeps building.
//

import Foundation

@available(*, deprecated, renamed: "MCError")
public typealias MIOCoreError = MCError

@available(*, deprecated, renamed: "MCErrorCode")
public typealias MIOErrorCode = MCErrorCode
