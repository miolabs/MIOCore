//
//  Deprecated+Param.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous param signatures. Use MCParam instead. Kept as forwards so downstream keeps building.
//

import Foundation

// MARK: - Generic

@available(*, deprecated, renamed: "MCParam.require(_:from:)")
public func MIOCoreParam<T>(_ dict: [String: Any?], _ name: String) throws -> T {
    try MCParam.require(name, from: dict)
}

@available(*, deprecated, renamed: "MCParam.require(_:from:validate:)")
public func MIOCoreParam<T>(_ dict: [String: Any?], _ name: String, _ whitelist_value: @escaping (_ value: Any) throws -> T) throws -> T {
    try MCParam.require(name, from: dict, validate: whitelist_value)
}

@available(*, deprecated, renamed: "MCParam.decode(_:from:_:)")
public func MIOCoreSafeParam<T>(_ dict: [String: Any?], _ name: String, _ whitelist_value: @escaping (_ value: Any?) throws -> T) throws -> T {
    try MCParam.decode(name, from: dict, whitelist_value)
}

@available(*, deprecated, renamed: "MCParam.optional(_:from:default:)")
public func optional_param<T>(_ dict: [String: Any?], _ name: String, _ def_value: @escaping () throws -> T) throws -> T {
    try MCParam.optional(name, from: dict, default: try def_value())
}

@available(*, deprecated, renamed: "MCParam.select(_:from:oneOf:)")
public func MIOCoreParamSelect<T: Equatable>(_ dict: [String: Any?], _ name: String, _ accepted_values: [T]) throws -> T {
    try MCParam.select(name, from: dict, oneOf: accepted_values)
}

// MARK: - Typed

@available(*, deprecated, renamed: "MCParam.int(_:from:default:)")
public func MIOCoreParamInt(_ dict: [String: Any?], _ name: String, _ def_value: Int? = nil) throws -> Int? {
    try MCParam.int(name, from: dict, default: def_value)
}

@available(*, deprecated, renamed: "MCParam.int16(_:from:default:)")
public func MIOCoreParamInt16(_ dict: [String: Any?], _ name: String, _ def_value: Int16? = nil) throws -> Int16? {
    try MCParam.int16(name, from: dict, default: def_value)
}

@available(*, deprecated, renamed: "MCParam.int32(_:from:default:)")
public func MIOCoreParamInt32(_ dict: [String: Any?], _ name: String, _ def_value: Int32? = nil) throws -> Int32? {
    try MCParam.int32(name, from: dict, default: def_value)
}

@available(*, deprecated, renamed: "MCParam.int64(_:from:default:)")
public func MIOCoreParamInt64(_ dict: [String: Any?], _ name: String, _ def_value: Int64? = nil) throws -> Int64? {
    try MCParam.int64(name, from: dict, default: def_value)
}

@available(*, deprecated, renamed: "MCParam.decimal(_:from:default:)")
public func MIOCoreParamDecimal(_ dict: [String: Any?], _ name: String, _ def_value: Decimal? = nil) throws -> Decimal? {
    try MCParam.decimal(name, from: dict, default: def_value)
}

@available(*, deprecated, renamed: "MCParam.bool(_:from:default:)")
public func MIOCoreParamBool(_ dict: [String: Any?], _ name: String, _ def_value: Bool? = nil) throws -> Bool? {
    try MCParam.bool(name, from: dict, default: def_value)
}
