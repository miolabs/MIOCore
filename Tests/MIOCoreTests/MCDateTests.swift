import XCTest

@testable import MIOCore

final class MCDateTests: XCTestCase {

    func testParseAcceptsKnownFormats() throws {
        XCTAssertNoThrow(try MCDate.parse("2026-07-30"))
        XCTAssertNoThrow(try MCDate.parse("2026-07-30 10:00:00"))
        XCTAssertNoThrow(try MCDate.parse("2026-07-30T10:00"))
        XCTAssertNoThrow(try MCDate.parse("2020-11-12T13:04:58Z"))
    }

    func testParseThrowsOnGarbage() {
        XCTAssertThrowsError(try MCDate.parse("not-a-date")) { error in
            guard case MCError.general = error else {
                return XCTFail("expected .general, got \(error)")
            }
        }
    }

    func testParseOrNil() {
        XCTAssertNotNil(MCDate.parseOrNil("2026-07-30"))
        XCTAssertNil(MCDate.parseOrNil("garbage"))
    }

    func testParseUTC() {
        XCTAssertNotNil(MCDate.parseUTC("2026-07-30"))
        XCTAssertNil(MCDate.parseUTC("garbage"))
    }

    // Same formatter both ways, so this is timezone-stable.
    func testFormatDayRoundTrip() throws {
        let d = try MCDate.parse("2026-07-30")
        XCTAssertEqual(MCDate.formatDay(d), "2026-07-30")
    }

    func testFormatTimeRoundTrip() throws {
        let t = try MCDate.parseTime("13:45")
        XCTAssertEqual(MCDate.formatTime(t), "13:45")
    }

    func testParseTimeOrNil() {
        XCTAssertNotNil(MCDate.parseTimeOrNil("09:15"))
        XCTAssertNil(MCDate.parseTimeOrNil("99"))
    }

    // Parse and format both in UTC so the result is platform-independent.
    func testUTCFormatIsStable() {
        let d = MCDate.parseUTC("2026-07-30")
        XCTAssertNotNil(d)
        XCTAssertEqual(MCDate.formatDayUTC(d!), "2026-07-30")
    }

    // The extractor reads the fractional digits itself and adds them (as microseconds)
    // onto the base date, so the result is base + 0.123456s exactly.
    func testMicrosecondsDatePreservesSubMillisecond() {
        let f = MCDate.iso8601Formatter()
        let s = "2026-07-30T10:00:00.123456Z"
        guard let base = f.date(from: s), let micro = f.microsecondsDate(from: s) else {
            return XCTFail("ISO8601 formatter could not parse \(s)")
        }
        XCTAssertEqual(
            micro.timeIntervalSince1970,
            base.timeIntervalSince1970 + 0.123456,
            accuracy: 1e-9)
    }
}
