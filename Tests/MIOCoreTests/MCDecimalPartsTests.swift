import XCTest

@testable import MIOCore

final class MCDecimalPartsTests: XCTestCase {

    private func decimal( _ s: String ) -> Decimal { Decimal( string: s )! }

    // Every value comes back identical, and the same value always gives the same parts.
    func testRoundTripIsExact() throws {
        let values: [Decimal] = [
            decimal( "0.1" ) + decimal( "0.2" ),
            decimal( "-3182.7" ),            // the >64-bit mantissa that broke NSDecimalNumber's integer accessors
            decimal( "-0.000000001" ),
            decimal( "-999999999.999999999" ),
            decimal( "123456789012345678901234567890.12345678" ),
            decimal( "340282366920938463463374607431768211455" ),   // widest mantissa, 2¹²⁸ − 1
            Decimal( 1_000_000_000 ),
            0,
            .greatestFiniteMagnitude,
            .leastNonzeroMagnitude,
            -Decimal.greatestFiniteMagnitude,
        ]
        for value in values {
            let parts = MCDecimalParts( value )
            let back = try parts.decimalValue()
            XCTAssertEqual( back, value, "\(value)" )
            XCTAssertEqual( MCDecimalParts( back ), parts, "\(value)" )
        }
    }

    func testPartsLayout() {
        XCTAssertEqual( MCDecimalParts( decimal( "-3182.7" ) ),
                        MCDecimalParts( isNegative: true, exponent: -1, limbs: [ 31827, 0, 0, 0, 0 ] ) )
        XCTAssertEqual( MCDecimalParts( decimal( "123456789012345678901234567890.12345678" ) ),
                        MCDecimalParts( exponent: -8, limbs: [ 12_345_678, 123_456_789, 234_567_890, 345_678_901, 12 ] ) )
        XCTAssertFalse( MCDecimalParts( decimal( "-0" ) ).isNegative )
    }

    func testNaN() throws {
        let parts = MCDecimalParts( Decimal.nan )
        XCTAssertTrue( parts.isNaN )
        XCTAssertTrue( try parts.decimalValue().isNaN )
    }

    // Parts built elsewhere (Python's decimal keeps the scale) need not be in Decimal's shape:
    // trailing zeros move into the exponent.
    func testForeignShapesNormalise() throws {
        // 10⁴⁰ written with 41 digits and exponent 0
        XCTAssertEqual( try MCDecimalParts( exponent: 0, limbs: [ 0, 0, 0, 0, 10_000 ] ).decimalValue(), decimal( "1e40" ) )
        // 5.00 is 5
        XCTAssertEqual( try MCDecimalParts( exponent: -2, limbs: [ 500, 0, 0, 0, 0 ] ).decimalValue(), 5 )
        // -12.3450 is -12.345
        XCTAssertEqual( try MCDecimalParts( isNegative: true, exponent: -4, limbs: [ 123_450, 0, 0, 0, 0 ] ).decimalValue(), decimal( "-12.345" ) )
    }

    // Never round: anything Decimal cannot hold exactly throws.
    func testUnrepresentableValuesThrow() {
        func assertThrows( _ parts: MCDecimalParts, _ expected: MCDecimalPartsError, line: UInt = #line ) {
            XCTAssertThrowsError( try parts.decimalValue(), line: line ) {
                XCTAssertEqual( $0 as? MCDecimalPartsError, expected, line: line )
            }
        }
        // 2¹²⁸ (one more than the widest mantissa), no trailing zero to trade
        let tooWide: [UInt32] = [ 768_211_456, 374_607_431, 938_463_463, 282_366_920, 340 ]
        assertThrows( MCDecimalParts( limbs: tooWide ), .mantissaTooWide( tooWide ) )
        // 10^-129 needs an exponent below -128
        assertThrows( MCDecimalParts( exponent: -129, limbs: [ 1, 0, 0, 0, 0 ] ), .exponentOutOfRange( -129 ) )
        // Too large: Decimal turns 1e129 (or 100e127) into NaN, so it has no exact value
        assertThrows( MCDecimalParts( exponent: 129, limbs: [ 1, 0, 0, 0, 0 ] ), .exponentOutOfRange( 129 ) )
        assertThrows( MCDecimalParts( exponent: 127, limbs: [ 100, 0, 0, 0, 0 ] ), .exponentOutOfRange( 127 ) )
        // Malformed limbs
        assertThrows( MCDecimalParts( limbs: [ 1_000_000_000, 0, 0, 0, 0 ] ), .invalidLimbs( [ 1_000_000_000, 0, 0, 0, 0 ] ) )
        assertThrows( MCDecimalParts( limbs: [ 1 ] ), .invalidLimbs( [ 1 ] ) )
    }

    // Currency arithmetic on values that crossed the boundary stays exact.
    func testCurrencyArithmeticAfterRoundTrip() throws {
        let price = try MCDecimalParts( decimal( "19.995" ) ).decimalValue()
        let units = try MCDecimalParts( decimal( "3" ) ).decimalValue()
        XCTAssertEqual( ( price * units ).roundingBy( scale: 2, roundingMode: .plain ), decimal( "59.99" ) )
    }
}
