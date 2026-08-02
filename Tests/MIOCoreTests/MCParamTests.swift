import XCTest
@testable import MIOCore

final class MCParamTests: XCTestCase {

    let body: [String: Any?] = [
        "accountID": "ACME",
        "amount": "25.00",
        "currency": "EUR",
        "count": "42",
        "flag": "yes",
        "page": 5,
    ]

    func testRequiredParam() throws {
        let id: String = try MIOCoreParam( body, "accountID" )
        XCTAssertEqual( id, "ACME" )
    }

    func testRequiredParamMissingThrows() {
        XCTAssertThrowsError( try { let _: String = try MIOCoreParam( body, "nope" ) }() ) { error in
            guard case MIOCoreError.invalidParameter = error else {
                return XCTFail( "expected .invalidParameter, got \(error)" )
            }
        }
    }

    func testWhitelistClosureParam() throws {
        let n: Int = try MIOCoreParam( body, "count" ) { raw in
            guard let i = MIOCoreIntValue( raw ), i >= 0 else {
                throw MIOCoreError.invalidParameterValue( "count", "\(raw)" )
            }
            return i
        }
        XCTAssertEqual( n, 42 )
    }

    func testSafeParamRunsClosureOnMissingKey() throws {
        let sawNil: Bool = try MIOCoreSafeParam( body, "missing" ) { $0 == nil }
        XCTAssertTrue( sawNil )
    }

    func testOptionalParam() throws {
        let page: Int = try optional_param( body, "page" ) { 1 }
        XCTAssertEqual( page, 5 )
        let missing: Int = try optional_param( body, "not_here" ) { 1 }
        XCTAssertEqual( missing, 1 )
    }

    func testTypedIntParams() throws {
        XCTAssertEqual( try MIOCoreParamInt( body, "count" ), 42 )
        XCTAssertEqual( try MIOCoreParamInt16( body, "count" ), 42 )
        XCTAssertEqual( try MIOCoreParamInt32( body, "count" ), 42 )
        XCTAssertEqual( try MIOCoreParamInt64( body, "count" ), 42 )
        XCTAssertEqual( try MIOCoreParamInt( body, "absent", 99 ), 99 )
    }

    func testTypedIntParamUnconvertibleThrows() {
        let bad: [String: Any?] = ["count": "abc"]
        XCTAssertThrowsError( try MIOCoreParamInt( bad, "count" ) ) { error in
            guard case MIOCoreError.invalidParameter = error else {
                return XCTFail( "expected .invalidParameter, got \(error)" )
            }
        }
    }

    func testDecimalAndBoolParams() throws {
        XCTAssertEqual( try MIOCoreParamDecimal( body, "amount" ), Decimal( string: "25.00" ) )
        XCTAssertEqual( try MIOCoreParamBool( body, "flag" ), true )
        XCTAssertEqual( try MIOCoreParamDecimal( body, "absent", 0 ), 0 )
        XCTAssertEqual( try MIOCoreParamBool( body, "absent", false ), false )
    }

    func testParamSelectWhitelist() throws {
        let currency: String = try MIOCoreParamSelect( body, "currency", ["EUR", "USD"] )
        XCTAssertEqual( currency, "EUR" )
    }

    func testParamSelectRejectsUnlistedValue() {
        let bad: [String: Any?] = ["currency": "GBP"]
        XCTAssertThrowsError( try { let _: String = try MIOCoreParamSelect( bad, "currency", ["EUR", "USD"] ) }() ) { error in
            guard case MIOCoreError.invalidParameterValue = error else {
                return XCTFail( "expected .invalidParameterValue, got \(error)" )
            }
        }
    }
}
