//
//  MCDecimal.swift
//
//  Created by MIO Research Labs on 19/09/2023.
//

import Foundation

/// Deprecated alias for ``MCDecimalValue(_:_:)``.
@available(*, deprecated, renamed: "MCDecimalValue", message: "Deprecated: change by MCDecimal instead")
public func MIOCoreDecimalValue ( _ value: Any?, _ def_value: Decimal? = nil ) -> Decimal? { return MCDecimalValue(value, def_value) }

/// Converts any value to a money-safe `Decimal` when it can.
///
/// The correct helper for currency: it accepts `NSDecimalNumber`, `Decimal`, any integer, or a
/// numeric `String`, and falls back to `def_value` otherwise. A `Double` input is routed through its
/// **shortest round-trip string** rather than `Decimal(_: Double)`, avoiding the binary-floating-point
/// noise that would otherwise leak into the mantissa (`-3182.7` staying `-3182.7`, not
/// `-3182.6999999999…`). This never throws.
///
/// ```swift
/// MCDecimalValue("19.99")   // 19.99 (exact)
/// MCDecimalValue(3)         // 3
/// MCDecimalValue(nil, 0)    // 0      (default used)
/// ```
///
/// - Parameters:
///   - value: The dynamic value to convert.
///   - def_value: The value returned when `value` is `nil`/unconvertible. Defaults to `nil`.
/// - Returns: The coerced `Decimal`, or `def_value` when conversion is not possible.
public func MCDecimalValue ( _ value: Any?, _ def_value: Decimal? = nil ) -> Decimal?
{
    if value == nil { return def_value }
    
    if let asDecimal = value! as? NSDecimalNumber { return asDecimal.decimalValue }
    if let asDouble  = value! as? Double  {
        // Decimal(floatLiteral:) carries the Double's binary noise into the mantissa
        // (-3182.7 -> -3182.6999999999999791, >64 bits). The shortest round-trip
        // string representation yields a clean, compact Decimal.
        if asDouble.isFinite == false { return Decimal.nan }
        return Decimal( string: "\(asDouble)" ) ?? Decimal( asDouble )
    }
    if let asDecimal = value! as? Decimal { return asDecimal }
    if MIOCoreIsIntValue( value ) { return Decimal( integerLiteral: MIOCoreIntValue( value )! ) }
    if let asString  = value! as? String  { return Decimal( string: asString ) ?? def_value }
        
    return def_value
}

extension Decimal
{
    /// Rounds to 2 decimal places using banker's rounding, the default for currency totals.
    ///
    /// Equivalent to `roundingBy(scale: 2, roundingMode: .bankers)`.
    ///
    /// - Returns: The value rounded to 2 fractional digits.
    public func rounding( ) -> Decimal { return roundingBy( scale: 2, roundingMode: .bankers ) }

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
    public func roundingBy( scale:Int, roundingMode: NSDecimalNumber.RoundingMode ) -> Decimal
    {
        var d = self
        var rounded = Decimal()
        NSDecimalRound( &rounded, &d, scale, roundingMode )
        return rounded
    }
}

extension NSDecimalNumber
{
    /// Rounds to 2 decimal places using banker's rounding, returning a `Decimal`.
    ///
    /// Bridges to `Decimal` first; see ``Foundation/Decimal/rounding()``.
    ///
    /// - Returns: The value rounded to 2 fractional digits.
    public func rounding( ) -> Decimal { return roundingBy( scale: 2, roundingMode: .bankers ) }

    /// Rounds to a fixed number of fractional digits using the given rounding mode, returning a `Decimal`.
    ///
    /// Bridges to `Decimal` first; see ``Foundation/Decimal/roundingBy(scale:roundingMode:)``.
    ///
    /// - Parameters:
    ///   - scale: The number of fractional digits to keep.
    ///   - roundingMode: The `NSDecimalNumber.RoundingMode` to apply.
    /// - Returns: The rounded value.
    public func roundingBy( scale:Int, roundingMode: NSDecimalNumber.RoundingMode ) -> Decimal
    {
        return (self as Decimal).roundingBy(scale: scale, roundingMode: roundingMode)
    }
}
