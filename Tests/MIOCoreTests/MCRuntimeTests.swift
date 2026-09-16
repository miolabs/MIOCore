import XCTest
@testable import MIOCore

final class MCRuntimeTests: XCTestCase {

    func testRegisterAndLookupClass() {
        _MIOCoreRegisterClass( type: NSString.self, forKey: "MC_TestKey" )
        let cls = _MIOCoreClassFromString( "MC_TestKey" )
        XCTAssertNotNil( cls )
        XCTAssertTrue( ObjectIdentifier( cls! ) == ObjectIdentifier( NSString.self ) )
    }

    func testLookupUnknownKeyReturnsNil() {
        XCTAssertNil( _MIOCoreClassFromString( "MC_NoSuchKey_\(#function)" ) )
    }

    func testAutoReleasePoolReturnsBodyResult() {
        let result = MIOCoreAutoReleasePool { 21 * 2 }
        XCTAssertEqual( result, 42 )
    }

    func testAutoReleasePoolRethrows() {
        struct Boom: Error {}
        XCTAssertThrowsError( try MIOCoreAutoReleasePool { throw Boom() } )
    }
}
