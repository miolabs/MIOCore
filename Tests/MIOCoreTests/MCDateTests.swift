import XCTest
@testable import MIOCore

final class MCDateTests: XCTestCase {

    func testParseDateAcceptsKnownFormats() throws {
        XCTAssertNoThrow( try parse_date( "2026-07-30" ) )
        XCTAssertNoThrow( try parse_date( "2026-07-30 10:00:00" ) )
        XCTAssertNoThrow( try parse_date( "2026-07-30T10:00" ) )
        XCTAssertNoThrow( try parse_date( "2020-11-12T13:04:58Z" ) )
    }

    func testParseDateThrowsOnGarbage() {
        XCTAssertThrowsError( try parse_date( "not-a-date" ) ) { error in
            guard case MIOCoreError.general = error else {
                return XCTFail( "expected .general, got \(error)" )
            }
        }
    }

    func testParseDateOrNil() {
        XCTAssertNotNil( parse_date_or_nil( "2026-07-30" ) )
        XCTAssertNil( parse_date_or_nil( nil ) )
        XCTAssertNil( parse_date_or_nil( "garbage" ) )
    }

    // Same formatter both ways, so this is timezone-stable.
    func testFormatDateRoundTrip() throws {
        let d = try parse_date( "2026-07-30" )
        XCTAssertEqual( format_date( d ), "2026-07-30" )
    }

    func testFormatTimeRoundTrip() throws {
        let t = try parse_time( "13:45" )
        XCTAssertEqual( format_time( t ), "13:45" )
    }

    func testParseTimeOrNil() {
        XCTAssertNotNil( parse_time_or_nil( "09:15" ) )
        XCTAssertNil( parse_time_or_nil( "99" ) )
    }

    // Parse and format both in GMT0 so the result is platform-independent.
    func testGMT0FormatIsStable() {
        let d = MCDateGMT0Parser( "2026-07-30" )
        XCTAssertNotNil( d )
        XCTAssertEqual( MCDateGMT0Format( d! ), "2026-07-30" )
    }

    // The extractor reads the fractional digits itself and adds them (as microseconds)
    // onto the base date, so the result is base + 0.123456s exactly.
    func testMicrosecondsDatePreservesSubMillisecond() {
        let f = MIOCoreISO8601Formatter()
        let s = "2026-07-30T10:00:00.123456Z"
        guard let base = f.date( from: s ), let micro = f.microsecondsDate( from: s ) else {
            return XCTFail( "ISO8601 formatter could not parse \(s)" )
        }
        XCTAssertEqual( micro.timeIntervalSince1970,
                        base.timeIntervalSince1970 + 0.123456,
                        accuracy: 1e-9 )
    }
}
