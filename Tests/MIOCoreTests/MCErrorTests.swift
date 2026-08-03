import XCTest

@testable import MIOCore

final class MCErrorTests: XCTestCase {

    func testGeneralDescription() {
        let desc = MCError.general("boom").errorDescription ?? ""
        XCTAssertTrue(desc.contains("[MCError]"))
        XCTAssertTrue(desc.contains("boom"))
    }

    func testInvalidParameterDescription() {
        let desc = MCError.invalidParameter("accountID").errorDescription ?? ""
        XCTAssertTrue(desc.contains("[MCError]"))
        XCTAssertTrue(desc.contains("accountID"))
    }

    func testInvalidParameterValueDescription() {
        let desc = MCError.invalidParameterValue("currency", "GBP").errorDescription ?? ""
        XCTAssertTrue(desc.contains("currency"))
        XCTAssertTrue(desc.contains("GBP"))
    }
}
