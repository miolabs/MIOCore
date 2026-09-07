//
//  Decimal+Extension.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension Decimal {
    /// Rounds to 2 decimal places using banker's rounding, the default for currency totals.
    ///
    /// Equivalent to `roundingBy(scale: 2, roundingMode: .bankers)`.
    ///
    /// - Returns: The value rounded to 2 fractional digits.
    public func rounding() -> Decimal { roundingBy(scale: 2, roundingMode: .bankers) }

    /// Rounds to a fixed number of fractional digits using the given rounding mode.
    ///
    /// ```swift
    /// Decimal(string: "19.995")!.roundingBy(scale: 2, roundingMode: .plain)   // 20.00
    /// ```
    ///
    /// - Parameters:
    ///   - scale: The number of fractional digits to keep.
    ///   - roundingMode: The `NSDecimalNumber.RoundingMode` to apply (e.g. `.bankers`, `.plain`).
    /// - Returns: The rounded value.
    public func roundingBy(scale: Int, roundingMode: NSDecimalNumber.RoundingMode) -> Decimal {
        var d = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &d, scale, roundingMode)
        return rounded
    }
}

extension NSDecimalNumber {
    /// Rounds to 2 decimal places using banker's rounding, returning a `Decimal`.
    ///
    /// Bridges to `Decimal` first; see ``Foundation/Decimal/rounding()``.
    ///
    /// - Returns: The value rounded to 2 fractional digits.
    public func rounding() -> Decimal { roundingBy(scale: 2, roundingMode: .bankers) }

    /// Rounds to a fixed number of fractional digits using the given rounding mode, returning a `Decimal`.
    ///
    /// Bridges to `Decimal` first; see ``Foundation/Decimal/roundingBy(scale:roundingMode:)``.
    ///
    /// - Parameters:
    ///   - scale: The number of fractional digits to keep.
    ///   - roundingMode: The `NSDecimalNumber.RoundingMode` to apply.
    /// - Returns: The rounded value.
    public func roundingBy(scale: Int, roundingMode: NSDecimalNumber.RoundingMode) -> Decimal {
        (self as Decimal).roundingBy(scale: scale, roundingMode: roundingMode)
    }
}
