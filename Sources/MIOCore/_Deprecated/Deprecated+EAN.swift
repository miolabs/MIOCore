//
//  Deprecated+EAN.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous EAN signatures. Use MCEAN instead. Kept as forwards so downstream keeps building.
//

import Foundation

@available(*, deprecated, renamed: "MCEAN.Standard")
public typealias EAN_TYPE = MCEAN.Standard

@available(*, deprecated, renamed: "MCEAN.generate(type:prefix:number:)")
public func MIOCoreGenerateEAN(type: MCEAN.Standard, prefix: String, number: Int64) -> String {
    MCEAN.generate(type: type, prefix: prefix, number: number)
}
