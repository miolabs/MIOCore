//
//  MCCast+UUID.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension MCCast {

    /// Converts any value to a `UUID`, optionally requiring a valid result.
    ///
    /// Accepts a real `UUID` or a `String` in UUID form. Unlike the never-throwing coercion helpers,
    /// this can throw: when `optional` is `false` and neither `value` nor `def` yields a UUID, it
    /// throws ``MCError/invalidParameterValue(_:_:)``. With the default `optional: true`, an
    /// unconvertible value simply returns `def` (or `nil`).
    ///
    /// ```swift
    /// try MCCast.uuid("6BA7B810-9DAD-11D1-80B4-00C04FD430C8")   // the UUID
    /// try MCCast.uuid("not-a-uuid")                             // nil (optional)
    /// try MCCast.uuid(nil, optional: false)                     // throws
    /// ```
    ///
    /// - Parameters:
    ///   - value: The dynamic value to convert (a `UUID` or a UUID string).
    ///   - def: The value returned when `value` cannot be converted. Defaults to `nil`.
    ///   - optional: When `false`, a missing/invalid result throws instead of returning `nil`.
    ///     Defaults to `true`.
    /// - Returns: The coerced `UUID`, or `def`.
    /// - Throws: ``MCError/invalidParameterValue(_:_:)`` when `optional` is `false` and no valid
    ///   UUID is available.
    public static func uuid(_ value: Any?, `default` def: UUID? = nil, optional: Bool = true) throws -> UUID? {
        var ret: UUID? = nil
        if let str = value as? String { ret = UUID(uuidString: str) } else if let uuid = value as? UUID { ret = uuid }

        if ret == nil && def == nil && optional == false {
            throw MCError.invalidParameterValue("\(String(describing: value))")
        }

        return ret ?? def
    }
}
