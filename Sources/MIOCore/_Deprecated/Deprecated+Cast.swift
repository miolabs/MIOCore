//
//  Deprecated+Cast.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous value-coercion signatures. Use MCCast instead. Kept as forwards so downstream keeps building.
//

import Foundation

// MARK: - Types

@available(*, deprecated, renamed: "MCCast.bool(_:default:)")
public func MIOCoreBoolValue(_ value: Any?, _ def_value: Bool? = nil) -> Bool? {
    MCCast.bool(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.double(_:default:)")
public func MIOCoreDoubleValue(_ value: Any?, _ def_value: Double? = nil) -> Double? {
    MCCast.double(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.float(_:default:)")
public func MIOCoreFloatValue(_ value: Any?, _ def_value: Float? = nil) -> Float? {
    MCCast.float(value, default: def_value)
}

// MARK: - Integer family

@available(*, deprecated, renamed: "MCCast.int(_:default:)")
public func MIOCoreIntValue(_ value: Any?, _ def_value: Int? = nil) -> Int? {
    MCCast.int(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.int8(_:default:)")
public func MIOCoreInt8Value(_ value: Any?, _ def_value: Int8? = nil) -> Int8? {
    MCCast.int8(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.int16(_:default:)")
public func MIOCoreInt16Value(_ value: Any?, _ def_value: Int16? = nil) -> Int16? {
    MCCast.int16(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.uint16(_:default:)")
public func MCUInt16Value(_ value: Any?, _ def_value: UInt16? = nil) -> UInt16? {
    MCCast.uint16(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.int32(_:default:)")
public func MIOCoreInt32Value(_ value: Any?, _ def_value: Int32? = nil) -> Int32? {
    MCCast.int32(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.uint32(_:default:)")
public func MIOCoreUInt32Value(_ value: Any?, _ def_value: UInt32? = nil) -> UInt32? {
    MCCast.uint32(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.int64(_:default:)")
public func MIOCoreInt64Value(_ value: Any?, _ def_value: Int64? = nil) -> Int64? {
    MCCast.int64(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.uint64(_:default:)")
public func MIOCoreUInt64Value(_ value: Any?, _ def_value: UInt64? = nil) -> UInt64? {
    MCCast.uint64(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.isInt(_:)")
public func MIOCoreIsIntValue(_ value: Any?) -> Bool {
    MCCast.isInt(value)
}

// MARK: - Decimal (money-safe)

@available(*, deprecated, renamed: "MCCast.decimal(_:default:)")
public func MCDecimalValue(_ value: Any?, _ def_value: Decimal? = nil) -> Decimal? {
    MCCast.decimal(value, default: def_value)
}

@available(*, deprecated, renamed: "MCCast.decimal(_:default:)")
public func MIOCoreDecimalValue(_ value: Any?, _ def_value: Decimal? = nil) -> Decimal? {
    MCCast.decimal(value, default: def_value)
}

// MARK: - UUID

@available(*, deprecated, renamed: "MCCast.uuid(_:default:optional:)")
public func MIOCoreUUIDValue(_ value: Any?, _ def_value: UUID? = nil, optional: Bool = true) throws -> UUID? {
    try MCCast.uuid(value, default: def_value, optional: optional)
}
