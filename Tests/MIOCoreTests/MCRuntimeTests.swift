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

    private class Root {}
    private class Middle: Root {}
    private final class Leaf: Middle {}

    func testSuperclassOfSwiftClasses() {
        XCTAssertTrue(MCRuntime.superclass(of: Leaf.self) == Middle.self)
        XCTAssertTrue(MCRuntime.superclass(of: Middle.self) == Root.self)
    }

    func testClassHierarchyIsMostSpecificFirst() {
        let chain = MCRuntime.classHierarchy(of: Leaf.self).map { ObjectIdentifier($0) }
        XCTAssertEqual(Array(chain.prefix(3)), [ObjectIdentifier(Leaf.self), ObjectIdentifier(Middle.self), ObjectIdentifier(Root.self)])
    }

    func testSuperclassOfFoundationClass() {
        XCTAssertTrue(MCRuntime.superclass(of: NSMutableString.self) == NSString.self)
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
