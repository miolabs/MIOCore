//
//  MIOCoreUUID.swift
//  
//
//  Created by Javier Segura Perez on 26/6/23.
//

import Foundation

/// Converts any value to a `UUID`, optionally requiring a valid result.
///
/// Accepts a real `UUID` or a `String` in UUID form. Unlike the never-throwing coercion helpers,
/// this can throw: when `optional` is `false` and neither `value` nor `def_value` yields a UUID, it
/// throws ``MIOCoreError/invalidParameterValue(_:_:)``. With the default `optional: true`, an
/// unconvertible value simply returns `def_value` (or `nil`).
///
/// ```swift
/// try MIOCoreUUIDValue("6BA7B810-9DAD-11D1-80B4-00C04FD430C8")   // the UUID
/// try MIOCoreUUIDValue("not-a-uuid")                             // nil (optional)
/// try MIOCoreUUIDValue(nil, optional: false)                     // throws
/// ```
///
/// - Parameters:
///   - value: The dynamic value to convert (a `UUID` or a UUID string).
///   - def_value: The value returned when `value` cannot be converted. Defaults to `nil`.
///   - optional: When `false`, a missing/invalid result throws instead of returning `nil`.
///     Defaults to `true`.
/// - Returns: The coerced `UUID`, or `def_value`.
/// - Throws: ``MIOCoreError/invalidParameterValue(_:_:)`` when `optional` is `false` and no valid
///   UUID is available.
public func MIOCoreUUIDValue ( _ value: Any?, _ def_value: UUID? = nil, optional: Bool = true ) throws -> UUID?
{
    var ret:UUID? = nil
    if let str = value as? String { ret = UUID( uuidString: str ) }
    else if let uuid = value as? UUID { ret = uuid }
    
    if ret == nil && def_value == nil && optional == false {
        throw MIOCoreError.invalidParameterValue( "\(String(describing: value))" )
    }
    
    return ret ?? def_value
}
