import XCTest
@testable import MIOCore

final class MCCastTests: XCTestCase {

    func testBoolValueCoercion() {
        XCTAssertEqual( MIOCoreBoolValue( true ), true )
        XCTAssertEqual( MIOCoreBoolValue( "yes" ), true )
        XCTAssertEqual( MIOCoreBoolValue( "TRUE" ), true )
        XCTAssertEqual( MIOCoreBoolValue( "1" ), true )
        XCTAssertEqual( MIOCoreBoolValue( 1 ), true )
        XCTAssertEqual( MIOCoreBoolValue( 0 ), false )
        XCTAssertEqual( MIOCoreBoolValue( "no" ), false )
    }

    func testBoolValueFallsBackToDefault() {
        XCTAssertNil( MIOCoreBoolValue( nil ) )
        XCTAssertEqual( MIOCoreBoolValue( nil, false ), false )
        XCTAssertEqual( MIOCoreBoolValue( NSNull(), true ), true )
    }

    func testIntValueCoercesAndTruncates() {
        XCTAssertEqual( MIOCoreIntValue( 42 ), 42 )
        XCTAssertEqual( MIOCoreIntValue( "42" ), 42 )
        XCTAssertEqual( MIOCoreIntValue( "3.9" ), 3 )
        XCTAssertEqual( MIOCoreIntValue( true ), 1 )
        XCTAssertEqual( MIOCoreIntValue( 3.9 ), 3 )
    }

    func testIntValueFallsBackToDefault() {
        XCTAssertEqual( MIOCoreIntValue( "abc", 0 ), 0 )
        XCTAssertNil( MIOCoreIntValue( nil ) )
        XCTAssertEqual( MIOCoreIntValue( nil, 7 ), 7 )
    }

    func testSizedIntValueClampsOutOfRange() {
        XCTAssertEqual( MIOCoreInt8Value( 200 as Int ), Int8.max )
        XCTAssertEqual( MIOCoreInt8Value( -200 as Int ), Int8.min )
        XCTAssertEqual( MIOCoreInt8Value( "100" ), 100 )
        XCTAssertEqual( MIOCoreInt16Value( 70000 as Int ), Int16.max )
        XCTAssertEqual( MIOCoreInt32Value( "-5" ), -5 )
        XCTAssertEqual( MIOCoreInt64Value( 9 as Int8 ), 9 )
        XCTAssertEqual( MIOCoreUInt32Value( "8" ), 8 )
        XCTAssertEqual( MIOCoreUInt64Value( 12 as Int ), 12 )
    }

    func testDoubleAndFloatCoercion() {
        XCTAssertEqual( MIOCoreDoubleValue( "3.14" ), 3.14 )
        XCTAssertEqual( MIOCoreDoubleValue( 3 as Int ), 3.0 )
        XCTAssertEqual( MIOCoreDoubleValue( Decimal( string: "2.5" )! ), 2.5 )
        XCTAssertEqual( MIOCoreFloatValue( "1.5" ), 1.5 )
        XCTAssertEqual( MIOCoreFloatValue( 4 as Int ), 4.0 )
        XCTAssertEqual( MIOCoreDoubleValue( "nope", 9.0 ), 9.0 )
    }

    func testIsIntValueMatchesLiveIntegers() {
        XCTAssertTrue( MIOCoreIsIntValue( 5 ) )
        XCTAssertTrue( MIOCoreIsIntValue( Int8( 5 ) ) )
        XCTAssertTrue( MIOCoreIsIntValue( Int64( 5 ) ) )
    }

    func testIsIntValueRejectsStringsFloatsAndNil() {
        XCTAssertFalse( MIOCoreIsIntValue( "5" ), "numeric strings must not coerce" )
        XCTAssertFalse( MIOCoreIsIntValue( 3.14 ) )
        XCTAssertFalse( MIOCoreIsIntValue( nil ) )
    }

    func testUUIDValueCoercesStringsAndUUIDs() throws {
        let s = "6BA7B810-9DAD-11D1-80B4-00C04FD430C8"
        XCTAssertEqual( try MIOCoreUUIDValue( s ), UUID( uuidString: s ) )
        XCTAssertEqual( try MIOCoreUUIDValue( UUID( uuidString: s )! ), UUID( uuidString: s ) )
        XCTAssertNil( try MIOCoreUUIDValue( "not-a-uuid" ) )
        let fallback = UUID()
        XCTAssertEqual( try MIOCoreUUIDValue( "not-a-uuid", fallback ), fallback )
    }

    func testUUIDValueThrowsWhenRequiredAndMissing() {
        XCTAssertThrowsError( try MIOCoreUUIDValue( nil, nil, optional: false ) ) { error in
            guard case MIOCoreError.invalidParameterValue = error else {
                return XCTFail( "expected .invalidParameterValue, got \(error)" )
            }
        }
    }
}
