import XCTest

@testable import MIOCore

final class MCParamTests: XCTestCase {

    let body: [String: Any?] = [
        "accountID": "cafe-central",
        "amount": "25.00",
        "currency": "EUR",
        "count": "42",
        "flag": "yes",
        "page": 5,
    ]

    func testRequiredParam() throws {
        let id: String = try MCParam.require("accountID", from: body)
        XCTAssertEqual(id, "cafe-central")
    }

    func testRequiredParamMissingThrows() {
        XCTAssertThrowsError(try { let _: String = try MCParam.require("nope", from: body) }()) { error in
            guard case MCError.invalidParameter = error else {
                return XCTFail("expected .invalidParameter, got \(error)")
            }
        }
    }

    func testWhitelistClosureParam() throws {
        let n: Int = try MCParam.require("count", from: body) { raw in
            guard let i = MCCast.int(raw), i >= 0 else {
                throw MCError.invalidParameterValue("count", "\(raw)")
            }
            return i
        }
        XCTAssertEqual(n, 42)
    }

    func testDecodeRunsClosureOnMissingKey() throws {
        let sawNil: Bool = try MCParam.decode("missing", from: body) { $0 == nil }
        XCTAssertTrue(sawNil)
    }

    func testOptionalParam() throws {
        let page: Int = try MCParam.optional("page", from: body, default: 1)
        XCTAssertEqual(page, 5)
        let missing: Int = try MCParam.optional("not_here", from: body, default: 1)
        XCTAssertEqual(missing, 1)
    }

    func testTypedIntParams() throws {
        XCTAssertEqual(try MCParam.int("count", from: body), 42)
        XCTAssertEqual(try MCParam.int16("count", from: body), 42)
        XCTAssertEqual(try MCParam.int32("count", from: body), 42)
        XCTAssertEqual(try MCParam.int64("count", from: body), 42)
        XCTAssertEqual(try MCParam.int("absent", from: body, default: 99), 99)
    }

    func testTypedIntParamUnconvertibleThrows() {
        let bad: [String: Any?] = ["count": "abc"]
        XCTAssertThrowsError(try MCParam.int("count", from: bad)) { error in
            guard case MCError.invalidParameter = error else {
                return XCTFail("expected .invalidParameter, got \(error)")
            }
        }
    }

    func testDecimalAndBoolParams() throws {
        XCTAssertEqual(try MCParam.decimal("amount", from: body), Decimal(string: "25.00"))
        XCTAssertEqual(try MCParam.bool("flag", from: body), true)
        XCTAssertEqual(try MCParam.decimal("absent", from: body, default: 0), 0)
        XCTAssertEqual(try MCParam.bool("absent", from: body, default: false), false)
    }

    func testParamSelectWhitelist() throws {
        let currency: String = try MCParam.select("currency", from: body, oneOf: ["EUR", "USD"])
        XCTAssertEqual(currency, "EUR")
    }

    func testParamSelectRejectsUnlistedValue() {
        let bad: [String: Any?] = ["currency": "GBP"]
        XCTAssertThrowsError(try { let _: String = try MCParam.select("currency", from: bad, oneOf: ["EUR", "USD"]) }()) { error in
            guard case MCError.invalidParameterValue = error else {
                return XCTFail("expected .invalidParameterValue, got \(error)")
            }
        }
    }
}
