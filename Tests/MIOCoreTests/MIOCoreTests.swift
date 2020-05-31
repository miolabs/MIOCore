import XCTest
@testable import MIOCore

final class MIOCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MIOCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
