import XCTest

@testable import MIOCore

final class MCEANTests: XCTestCase {

    func testEAN13WithoutPrefix() {
        let code = MCEAN.generate(type: .ean13, prefix: "", number: 4)
        XCTAssertEqual(code, "0000000000048")
        XCTAssertEqual(code.count, 13)
    }

    func testEAN13WithPrefix() {
        let code = MCEAN.generate(type: .ean13, prefix: "113060", number: 4)
        XCTAssertEqual(code, "1130600000045")
        XCTAssertEqual(code.count, 13)
    }

    func testEAN8WithPrefix() {
        let code = MCEAN.generate(type: .ean8, prefix: "103060", number: 4)
        XCTAssertEqual(code, "10306046")
        XCTAssertEqual(code.count, 8)
    }

    func testEANStandardRawValueIsDigitCount() {
        XCTAssertEqual(MCEAN.Standard.ean8.rawValue, 8)
        XCTAssertEqual(MCEAN.Standard.ean13.rawValue, 13)
    }
}
