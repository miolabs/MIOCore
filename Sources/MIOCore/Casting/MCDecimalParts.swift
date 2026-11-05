//
//  MCDecimalParts.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// A `Decimal` as plain integers, to hand it across a C boundary (Python, C, C++) without losing a digit.
///
/// The value is `(-1)^isNegative · mantissa · 10^exponent`, where the mantissa is written in
/// ``limbCount`` little-endian base-10⁹ limbs: `mantissa = Σ limbs[i] · 10^(9·i)`. Nothing goes through
/// `Double` or a string, so currency amounts stay exact. Only the public `Decimal` API is used: its raw
/// fields (`_mantissa`, `_exponent`) are internal on Linux.
///
/// ```swift
/// let parts = MCDecimalParts(Decimal(string: "-3182.7")!)  // isNegative, exponent -1, limbs [31827, 0, 0, 0, 0]
/// let back  = try parts.decimalValue()                      // -3182.7
/// ```
///
/// Building a `Decimal` from parts never rounds: a mantissa wider than `Decimal` holds (2¹²⁸ − 1) or an
/// exponent it cannot reach throws ``MCDecimalPartsError`` instead.
public struct MCDecimalParts: Equatable, Sendable
{
    /// Number of base-10⁹ limbs: 45 digits, enough for `Decimal`'s 128-bit mantissa (39 digits).
    public static let limbCount = 5
    /// Each limb holds nine decimal digits.
    public static let limbBase: UInt32 = 1_000_000_000

    public var isNegative: Bool
    public var isNaN: Bool
    /// Power of ten applied to the mantissa.
    public var exponent: Int32
    /// Mantissa, least significant limb first; each limb is below ``limbBase``.
    public var limbs: [UInt32]

    public init( isNegative: Bool = false, isNaN: Bool = false, exponent: Int32 = 0, limbs: [UInt32] ) {
        self.isNegative = isNegative
        self.isNaN = isNaN
        self.exponent = exponent
        self.limbs = limbs
    }

    /// The exact parts of `value`. Zero is never negative; NaN only sets ``isNaN``.
    public init( _ value: Decimal ) {
        if value.isNaN {
            self.init( isNaN: true, limbs: [UInt32]( repeating: 0, count: Self.limbCount ) )
            return
        }
        let base = Decimal( Self.limbBase )
        var mantissa = value.significand.magnitude   // an integer: the exponent is kept apart
        var limbs: [UInt32] = []
        for _ in 0..<Self.limbCount {
            var quotient = mantissa / base   // dividing by a power of ten only moves the exponent: exact
            var whole = Decimal()
            NSDecimalRound( &whole, &quotient, 0, .down )
            let limb = mantissa - whole * base   // exact, 0 ≤ limb < 10⁹
            limbs.append( ( limb as NSDecimalNumber ).uint32Value )
            mantissa = whole
        }
        self.init( isNegative: value.sign == .minus && !value.isZero, exponent: Int32( value.exponent ), limbs: limbs )
    }

    /// The `Decimal` these parts spell, exactly.
    ///
    /// Trailing zeros of the mantissa move into the exponent, as `Decimal` stores them. A value whose
    /// exponent then falls outside -128...127, or whose mantissa is wider than 128 bits, throws rather
    /// than round (`Decimal` itself cannot hold 1e129: it turns it into NaN).
    public func decimalValue() throws -> Decimal {
        if isNaN { return .nan }
        guard limbs.count == Self.limbCount, limbs.allSatisfy( { $0 < Self.limbBase } ) else {
            throw MCDecimalPartsError.invalidLimbs( limbs )
        }

        var mantissa = limbs
        var exponent = Int( self.exponent )
        if Self.isZero( mantissa ) { return 0 }

        // Decimal always keeps the shortest mantissa (100 is 1·10²), so trailing zeros go to the exponent
        while let ( quotient, remainder ) = Self.divideByTen( mantissa ), remainder == 0 {
            mantissa = quotient
            exponent += 1
        }
        guard Self.fitsDecimal( mantissa ) else { throw MCDecimalPartsError.mantissaTooWide( limbs ) }

        let base = Decimal( Self.limbBase )
        var significand = Decimal( 0 )
        for limb in mantissa.reversed() { significand = significand * base + Decimal( limb ) }   // exact: fits 128 bits
        let value = Decimal( sign: isNegative ? .minus : .plus, exponent: exponent, significand: significand )
        // Outside -128...127 Decimal gives NaN (or another value): compare instead of trusting the range
        guard !value.isNaN, MCDecimalParts( value ).sameValue( as: mantissa, exponent: exponent ) else {
            throw MCDecimalPartsError.exponentOutOfRange( self.exponent )
        }
        return value
    }

    // MARK: - Mantissa arithmetic on limbs (no Decimal rounding involved)

    /// 2¹²⁸ − 1, the widest mantissa a `Decimal` holds, in limbs.
    private static let maxMantissa: [UInt32] = [ 768_211_455, 374_607_431, 938_463_463, 282_366_920, 340 ]

    private static func isZero( _ m: [UInt32] ) -> Bool { m.allSatisfy { $0 == 0 } }

    private static func fitsDecimal( _ m: [UInt32] ) -> Bool {
        for i in stride( from: limbCount - 1, through: 0, by: -1 ) where m[ i ] != maxMantissa[ i ] {
            return m[ i ] < maxMantissa[ i ]
        }
        return true
    }

    private static func divideByTen( _ m: [UInt32] ) -> ( [UInt32], UInt32 )? {
        if isZero( m ) { return nil }
        var quotient = m
        var remainder: UInt64 = 0
        for i in stride( from: limbCount - 1, through: 0, by: -1 ) {
            let current = remainder * UInt64( limbBase ) + UInt64( m[ i ] )
            quotient[ i ] = UInt32( current / 10 )
            remainder = current % 10
        }
        return ( quotient, UInt32( remainder ) )
    }

    /// Whether these parts hold the same value as `mantissa · 10^exponent` (both may carry trailing zeros).
    private func sameValue( as mantissa: [UInt32], exponent: Int ) -> Bool {
        func normalized( _ m: [UInt32], _ e: Int ) -> ( [UInt32], Int ) {
            var m = m, e = e
            while let ( q, r ) = Self.divideByTen( m ), r == 0 { m = q; e += 1 }
            return ( m, e )
        }
        return normalized( limbs, Int( self.exponent ) ) == normalized( mantissa, exponent )
    }
}

public enum MCDecimalPartsError: Error, Equatable {
    /// Not ``MCDecimalParts/limbCount`` limbs, or a limb not below ``MCDecimalParts/limbBase``.
    case invalidLimbs( [UInt32] )
    /// The mantissa is wider than `Decimal`'s 128 bits (about 38 digits).
    case mantissaTooWide( [UInt32] )
    /// The value needs an exponent `Decimal` cannot reach, even after moving trailing zeros.
    case exponentOutOfRange( Int32 )
}
