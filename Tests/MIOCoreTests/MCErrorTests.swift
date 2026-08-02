import XCTest
@testable import MIOCore

final class MCErrorTests: XCTestCase {

    func testGeneralDescription() {
        let desc = MIOCoreError.general( "boom" ).errorDescription ?? ""
        XCTAssertTrue( desc.contains( "[MIOCoreError]" ) )
        XCTAssertTrue( desc.contains( "boom" ) )
    }

    func testInvalidParameterDescription() {
        let desc = MIOCoreError.invalidParameter( "accountID" ).errorDescription ?? ""
        XCTAssertTrue( desc.contains( "[MIOCoreError]" ) )
        XCTAssertTrue( desc.contains( "accountID" ) )
    }

    func testInvalidParameterValueDescription() {
        let desc = MIOCoreError.invalidParameterValue( "currency", "GBP" ).errorDescription ?? ""
        XCTAssertTrue( desc.contains( "currency" ) )
        XCTAssertTrue( desc.contains( "GBP" ) )
    }
}
