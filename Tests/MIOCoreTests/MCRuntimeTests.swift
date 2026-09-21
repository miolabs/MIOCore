import XCTest

@testable import MIOCore

final class MCRuntimeTests: XCTestCase {

    func testRegisterAndLookupClass() {
        MCRuntime.registerClass(NSString.self, forKey: "MC_TestKey")
        let cls: AnyClass? = MCRuntime.classFromString("MC_TestKey")
        XCTAssertNotNil(cls)
        XCTAssertTrue(ObjectIdentifier(cls!) == ObjectIdentifier(NSString.self))
    }

    func testLookupUnknownKeyReturnsNil() {
        XCTAssertNil(MCRuntime.classFromString("MC_NoSuchKey_\(#function)"))
    }

    func testAutoReleasePoolReturnsBodyResult() {
        let result = MCRuntime.autoReleasePool { 21 * 2 }
        XCTAssertEqual(result, 42)
    }

    func testAutoReleasePoolRethrows() {
        struct Boom: Error {}
        XCTAssertThrowsError(try MCRuntime.autoReleasePool { throw Boom() })
    }
}
