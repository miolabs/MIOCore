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

    // MARK: - Strict xValue variants

    private enum AppError: Error, Equatable { case missingFlag }

    func testStrictVariantsReturnCoercedValue() throws {
        XCTAssertEqual(try MCCast.boolValue("yes"), true)
        XCTAssertEqual(try MCCast.intValue("42"), 42)
        XCTAssertEqual(try MCCast.int8Value("100"), 100)
        XCTAssertEqual(try MCCast.int16Value(7), 7)
        XCTAssertEqual(try MCCast.uint16Value(7 as Int), 7)
        XCTAssertEqual(try MCCast.int32Value("7"), 7)
        XCTAssertEqual(try MCCast.uint32Value(7 as UInt8), 7)
        XCTAssertEqual(try MCCast.int64Value(7), 7)
        XCTAssertEqual(try MCCast.uint64Value(7), 7)
        XCTAssertEqual(try MCCast.doubleValue("1.5"), 1.5)
        XCTAssertEqual(try MCCast.floatValue(1.5), 1.5)
        XCTAssertEqual(try MCCast.decimalValue("19.99"), Decimal(string: "19.99"))
        XCTAssertEqual(try MCCast.uuidValue("6BA7B810-9DAD-11D1-80B4-00C04FD430C8"),
                       UUID(uuidString: "6BA7B810-9DAD-11D1-80B4-00C04FD430C8"))
    }

    func testStrictVariantsUseDefaultBeforeThrowing() throws {
        XCTAssertEqual(try MCCast.boolValue(nil, default: false), false)
        XCTAssertEqual(try MCCast.intValue("abc", default: 0), 0)
        XCTAssertEqual(try MCCast.int8Value("abc", default: 5), 5)
        XCTAssertEqual(try MCCast.doubleValue(nil, default: 2), 2)
    }

    func testStrictVariantsThrowCastErrorOnNilOrUnconvertible() {
        let calls: [() throws -> Any] = [
            { try MCCast.boolValue(nil) },
            { try MCCast.intValue("abc") },
            { try MCCast.int8Value(nil) },
            { try MCCast.int16Value("x") },
            { try MCCast.uint16Value(nil) },
            { try MCCast.int32Value(nil) },
            { try MCCast.uint32Value(nil) },
            { try MCCast.int64Value(nil) },
            { try MCCast.uint64Value(nil) },
            { try MCCast.doubleValue(nil) },   // used to crash on the force-unwrap
            { try MCCast.floatValue(nil) },
            { try MCCast.decimalValue("abc") },
            { try MCCast.uuidValue("not-a-uuid") },
        ]
        for call in calls {
            XCTAssertThrowsError(try call()) { error in
                guard case MCCastError.invalidValue = error else { return XCTFail("unexpected \(error)") }
            }
        }
    }

    func testStrictVariantsThrowCustomError() {
        XCTAssertThrowsError(try MCCast.boolValue(nil, error: AppError.missingFlag)) { error in
            XCTAssertEqual(error as? AppError, .missingFlag)
        }
        XCTAssertThrowsError(try MCCast.intValue("abc", error: AppError.missingFlag)) { error in
            XCTAssertEqual(error as? AppError, .missingFlag)
        }
    }

    func testCastErrorDescriptionNamesValueAndType() {
        let desc = MCCastError.invalidValue("abc", type: Int.self).errorDescription ?? ""
        XCTAssertTrue(desc.contains("\"abc\""))
        XCTAssertTrue(desc.contains("Int"))
    }

    func testBareCastsStayUnambiguousWithoutTypeContext() {
        let flag = MCCast.bool("yes")
        let count = MCCast.int("3")
        XCTAssertEqual(flag, true)
        XCTAssertEqual(count, 3)
    }
}
