//
//  Deprecated+Runtime.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous runtime signatures. Use MCRuntime instead. Kept as forwards so downstream keeps building.
//

import Foundation

// NOTE: these two aren't deprecated on purpose. Codegen (MIOCoreDataTools, MIOJSLibs) emits
// _MIOCoreRegisterClass(...) into generated files, so deprecating would flood them with warnings.
// They stay plain forwards until the codegen templates emit MCRuntime.registerClass / classFromString.
public func _MIOCoreRegisterClass(type: AnyClass, forKey key: String) {
    MCRuntime.registerClass(type, forKey: key)
}

public func _MIOCoreClassFromString(_ key: String) -> AnyClass? {
    MCRuntime.classFromString(key)
}

@available(*, deprecated, renamed: "MCRuntime.autoReleasePool(invoking:)")
public func MIOCoreAutoReleasePool<Result>(invoking body: () throws -> Result) rethrows -> Result {
    try MCRuntime.autoReleasePool(invoking: body)
}
