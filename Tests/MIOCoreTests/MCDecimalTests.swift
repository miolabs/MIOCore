import XCTest
@testable import MIOCore

final class MCDecimalTests: XCTestCase {

    // Doubles must convert through the shortest round-trip string so the resulting
    // Decimal is clean (-3182.7), not the binary-noise value (-3182.6999999999999791)
    // whose >64-bit mantissa breaks NSDecimalNumber's integer accessors.
    func testDecimalValueFromDoubleIsClean() throws {
        let d = MCDecimalValue( -3182.7 as Double )!
        XCTAssertEqual( d, Decimal( string: "-3182.7" )! )
        XCTAssertEqual( MIOCoreIntValue( d * 100 ), -318270 )

        let up = MCDecimalValue( 3182.7 as Double )!
        XCTAssertEqual( up, Decimal( string: "3182.7" )! )
        XCTAssertEqual( MIOCoreIntValue( up * 100 ), 318270 )

        // Double noise that IS the shortest representation survives exactly
        let noisy = MCDecimalValue( 0.1 + 0.2 )!
        XCTAssertEqual( noisy, Decimal( string: "0.30000000000000004" )! )
    }

    func testDecimalValueNonFiniteDoubles() throws {
        XCTAssertTrue( MCDecimalValue( Double.nan )!.isNaN )
        XCTAssertTrue( MCDecimalValue( Double.infinity )!.isNaN )
    }

    func testDecimalValueExactPathsUnchanged() throws {
        let exact = Decimal( string: "-3182.7" )!
        XCTAssertEqual( MCDecimalValue( exact ), exact )
        XCTAssertEqual( MCDecimalValue( NSDecimalNumber( decimal: exact ) ), exact )
        XCTAssertEqual( MCDecimalValue( 42 ), Decimal( 42 ) )
        XCTAssertEqual( MCDecimalValue( "-3182.7" ), exact )
    }

    // Regression: the exact Decimal from the DLPaymentServer debugger session.
    // NSDecimalNumber integer accessors return garbage (50664) for mantissas that
    // need more than 64 bits; MIOCoreInt*Value must round to scale 0 first.
    func testIntValueFromOversizedMantissa() throws {
        let dirty = Decimal(_exponent: -14, _length: 5, _isNegative: 1, _isCompact: 1, _reserved: 0,
                            _mantissa: (32559, 37467, 14303, 47536, 1, 0, 0, 0)) // -318269.99999999999791
        XCTAssertEqual( MIOCoreIntValue( dirty ), -318270 )
        XCTAssertEqual( MIOCoreInt64Value( dirty ), -318270 )
        XCTAssertEqual( MIOCoreIntValue( NSDecimalNumber( decimal: dirty ) ), -318270 )

        // Plain NSNumber semantics unchanged: truncation, no rounding
        XCTAssertEqual( MIOCoreIntValue( NSNumber( value: 3.9 ) ), 3 )
    }
}
