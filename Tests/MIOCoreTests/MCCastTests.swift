import XCTest

@testable import MIOCore

final class MCCastTests: XCTestCase {

    func testBoolValueCoercion() {
        XCTAssertEqual(MCCast.bool(true), true)
        XCTAssertEqual(MCCast.bool("yes"), true)
        XCTAssertEqual(MCCast.bool("TRUE"), true)
        XCTAssertEqual(MCCast.bool("1"), true)
        XCTAssertEqual(MCCast.bool(1), true)
        XCTAssertEqual(MCCast.bool(0), false)
        XCTAssertEqual(MCCast.bool("no"), false)
    }

    func testBoolValueFallsBackToDefault() {
        XCTAssertNil(MCCast.bool(nil))
        XCTAssertEqual(MCCast.bool(nil, default: false), false)
        XCTAssertEqual(MCCast.bool(NSNull(), default: true), true)
    }

    func testIntValueCoercesAndTruncates() {
        XCTAssertEqual(MCCast.int(42), 42)
        XCTAssertEqual(MCCast.int("42"), 42)
        XCTAssertEqual(MCCast.int("3.9"), 3)
        XCTAssertEqual(MCCast.int(true), 1)
        XCTAssertEqual(MCCast.int(3.9), 3)
    }

    func testIntValueFallsBackToDefault() {
        XCTAssertEqual(MCCast.int("abc", default: 0), 0)
        XCTAssertNil(MCCast.int(nil))
        XCTAssertEqual(MCCast.int(nil, default: 7), 7)
    }

    func testSizedIntValueClampsOutOfRange() {
        XCTAssertEqual(MCCast.int8(200 as Int), Int8.max)
        XCTAssertEqual(MCCast.int8(-200 as Int), Int8.min)
        XCTAssertEqual(MCCast.int8("100"), 100)
        XCTAssertEqual(MCCast.int16(70000 as Int), Int16.max)
        XCTAssertEqual(MCCast.int32("-5"), -5)
        XCTAssertEqual(MCCast.int64(9 as Int8), 9)
        XCTAssertEqual(MCCast.uint32("8"), 8)
        XCTAssertEqual(MCCast.uint64(12 as Int), 12)
    }

    func testDoubleAndFloatCoercion() {
        XCTAssertEqual(MCCast.double("3.14"), 3.14)
        XCTAssertEqual(MCCast.double(3 as Int), 3.0)
        XCTAssertEqual(MCCast.double(Decimal(string: "2.5")!), 2.5)
        XCTAssertEqual(MCCast.float("1.5"), 1.5)
        XCTAssertEqual(MCCast.float(4 as Int), 4.0)
        XCTAssertEqual(MCCast.double("nope", default: 9.0), 9.0)
    }

    func testIsIntValueMatchesLiveIntegers() {
        XCTAssertTrue(MCCast.isInt(5))
        XCTAssertTrue(MCCast.isInt(Int8(5)))
        XCTAssertTrue(MCCast.isInt(Int64(5)))
    }

    func testIsIntValueRejectsStringsFloatsAndNil() {
        XCTAssertFalse(MCCast.isInt("5"), "numeric strings must not coerce")
        XCTAssertFalse(MCCast.isInt(3.14))
        XCTAssertFalse(MCCast.isInt(nil))
    }

    func testUUIDValueCoercesStringsAndUUIDs() throws {
        let s = "6BA7B810-9DAD-11D1-80B4-00C04FD430C8"
        XCTAssertEqual(try MCCast.uuid(s), UUID(uuidString: s))
        XCTAssertEqual(try MCCast.uuid(UUID(uuidString: s)!), UUID(uuidString: s))
        XCTAssertNil(try MCCast.uuid("not-a-uuid"))
        let fallback = UUID()
        XCTAssertEqual(try MCCast.uuid("not-a-uuid", default: fallback), fallback)
    }

    func testUUIDValueThrowsWhenRequiredAndMissing() {
        XCTAssertThrowsError(try MCCast.uuid(nil, default: nil, optional: false)) { error in
            guard case MCError.invalidParameterValue = error else {
                return XCTFail("expected .invalidParameterValue, got \(error)")
            }
        }
    }
}
