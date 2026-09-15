import XCTest

@testable import MIOCore

final class DecimalStringTests: XCTestCase {

    struct Payload : Codable {
        @DecimalString var amount: Decimal
    }

    // The wire format is a string, so the value never goes through Double.
    func testEncodesDecimalAsJSONString() throws {
        let data = try JSONEncoder().encode( Payload( amount: Decimal( string: "19.99" )! ) )
        XCTAssertEqual( String( data: data, encoding: .utf8 ), "{\"amount\":\"19.99\"}" )
    }

    func testDecodesStringExactly() throws {
        let p = try JSONDecoder().decode( Payload.self, from: Data( "{\"amount\":\"-3182.7\"}".utf8 ) )
        XCTAssertEqual( p.amount, Decimal( string: "-3182.7" )! )
    }

    // A bare JSON number is tolerated and scrubbed of its binary noise.
    func testDecodesBareNumberWithoutDoubleNoise() throws {
        let p = try JSONDecoder().decode( Payload.self, from: Data( "{\"amount\":-3182.7}".utf8 ) )
        XCTAssertEqual( p.amount, Decimal( string: "-3182.7" )! )
    }

    func testRejectsNonNumericString() {
        XCTAssertThrowsError( try JSONDecoder().decode( Payload.self, from: Data( "{\"amount\":\"abc\"}".utf8 ) ) )
    }
}
