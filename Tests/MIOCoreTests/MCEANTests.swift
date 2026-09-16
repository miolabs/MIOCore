import XCTest
@testable import MIOCore

final class MCEANTests: XCTestCase {

    func testEAN13WithoutPrefix() {
        let code = MIOCoreGenerateEAN( type: .ean13, prefix: "", number: 4 )
        XCTAssertEqual( code, "0000000000048" )
        XCTAssertEqual( code.count, 13 )
    }

    func testEAN13WithPrefix() {
        let code = MIOCoreGenerateEAN( type: .ean13, prefix: "113060", number: 4 )
        XCTAssertEqual( code, "1130600000045" )
        XCTAssertEqual( code.count, 13 )
    }

    func testEAN8WithPrefix() {
        let code = MIOCoreGenerateEAN( type: .ean8, prefix: "103060", number: 4 )
        XCTAssertEqual( code, "10306046" )
        XCTAssertEqual( code.count, 8 )
    }

    func testEANTypeRawValueIsDigitCount() {
        XCTAssertEqual( EAN_TYPE.ean8.rawValue, 8 )
        XCTAssertEqual( EAN_TYPE.ean13.rawValue, 13 )
    }
}
