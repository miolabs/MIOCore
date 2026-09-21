import XCTest

@testable import MIOCore

final class MCDecimalTests: XCTestCase {

    // Doubles must convert through the shortest round-trip string so the resulting
    // Decimal is clean (-3182.7), not the binary-noise value (-3182.6999999999999791)
    // whose >64-bit mantissa breaks NSDecimalNumber's integer accessors.
    func testDecimalValueFromDoubleIsClean() throws {
        let d = MCCast.decimal(-3182.7 as Double)!
        XCTAssertEqual(d, Decimal(string: "-3182.7")!)
        XCTAssertEqual(MCCast.int(d * 100), -318270)

        let up = MCCast.decimal(3182.7 as Double)!
        XCTAssertEqual(up, Decimal(string: "3182.7")!)
        XCTAssertEqual(MCCast.int(up * 100), 318270)

        // Double noise that IS the shortest representation survives exactly
        let noisy = MCCast.decimal(0.1 + 0.2)!
        XCTAssertEqual(noisy, Decimal(string: "0.30000000000000004")!)
    }

    func testDecimalValueNonFiniteDoubles() throws {
        XCTAssertTrue(MCCast.decimal(Double.nan)!.isNaN)
        XCTAssertTrue(MCCast.decimal(Double.infinity)!.isNaN)
    }

    func testDecimalValueExactPathsUnchanged() throws {
        let exact = Decimal(string: "-3182.7")!
        XCTAssertEqual(MCCast.decimal(exact), exact)
        XCTAssertEqual(MCCast.decimal(NSDecimalNumber(decimal: exact)), exact)
        XCTAssertEqual(MCCast.decimal(42), Decimal(42))
        XCTAssertEqual(MCCast.decimal("-3182.7"), exact)
    }

    // Regression: the exact Decimal from the DLPaymentServer debugger session.
    // NSDecimalNumber integer accessors return garbage (50664) for mantissas that
    // need more than 64 bits; MIOCoreInt*Value must round to scale 0 first.
    //
    // Darwin only, and not by choice: reproducing the bug needs that specific mantissa,
    // which means Decimal's memberwise internal initialiser. swift-corelibs-foundation
    // does not expose it, so on Linux this does not compile rather than merely fail,
    // which is why it has to be #if'd out instead of skipped at runtime. Constructing the
    // value from a string would not do: the bug depends on the mantissa being long, and a
    // parsed literal may compact it away.
    #if canImport(Darwin)
    func testIntValueFromOversizedMantissa() throws {
        let dirty = Decimal(
            _exponent: -14, _length: 5, _isNegative: 1, _isCompact: 1, _reserved: 0,
            _mantissa: (32559, 37467, 14303, 47536, 1, 0, 0, 0))  // -318269.99999999999791
        XCTAssertEqual(MCCast.int(dirty), -318270)
        XCTAssertEqual(MCCast.int64(dirty), -318270)
        XCTAssertEqual(MCCast.int(NSDecimalNumber(decimal: dirty)), -318270)

        // Plain NSNumber semantics unchanged: truncation, no rounding
        XCTAssertEqual(MCCast.int(NSNumber(value: 3.9)), 3)
    }
    #endif
}
