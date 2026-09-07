//
//  Deprecated+JSON.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous JSON signatures. Use MCJSON instead. Kept as forwards so downstream keeps building.
//

import Foundation

@available(*, deprecated, renamed: "MCJSON.data(from:options:)")
public func MIOCoreJsonValue(withJSONObject obj: Any, options opt: JSONSerialization.WritingOptions = []) throws -> Data {
    try MCJSON.data(from: obj, options: opt)
}

@available(*, deprecated, renamed: "MCJSON.string(from:options:)")
public func MIOCoreJsonStringify(withJSONObject obj: Any, options opt: JSONSerialization.WritingOptions = []) throws -> String? {
    try MCJSON.string(from: obj, options: opt)
}

@available(*, deprecated, renamed: "MCJSON.serializable(_:)")
public func MIOCoreSerializableJSON(_ obj: Any) -> Any {
    MCJSON.serializable(obj)
}
