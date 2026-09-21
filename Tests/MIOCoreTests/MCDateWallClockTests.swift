import XCTest

@testable import MIOCore

/// The wall-clock wire contract.
///
/// Serialization renders a `Date` in the PROCESS time zone into strings that carry no offset,
/// and parsing reads those strings back in the process time zone, ignoring any embedded zone
/// marker. A date that reads 16:00 where it was created must serialize as "16:00" and parse
/// back as 16:00 local — on a GMT pod, a POS in Madrid, or a device in Dubai — so the wall
/// time survives every leg of POS -> sync -> DB -> manager unchanged.
///
/// Regression guard: pinning the patterned formatters to UTC (2026-08/09) inverted this on
/// devices — a POS in Madrid serialized a 16:00 sale as "14:00" and displayed server "16:00"
/// as 18:00. These tests run the public API on fresh threads with the default time zone forced
/// to Madrid and Dubai, so they fail if anyone pins the formatters to a fixed zone again.
final class MCDateWallClockTests: XCTestCase {

    private let day = "2026-08-13"
    private let wall = "2026-08-13 16:00:00"

    /// Runs `body` on a fresh thread with the default time zone forced to `identifier`.
    /// The fresh thread guarantees a cold per-thread formatter cache, so every formatter is
    /// created under the forced zone — exactly like code running on a device booted there.
    private func withTimeZone(_ identifier: String, _ body: @escaping () -> Void) {
        guard let tz = TimeZone(identifier: identifier) else {
            return XCTFail("Unknown time zone \(identifier)")
        }
        let saved = NSTimeZone.default
        NSTimeZone.default = tz
        defer { NSTimeZone.default = saved }

        let done = expectation(description: "wall-clock body in \(identifier)")
        let thread = Thread {
            body()
            done.fulfill()
        }
        thread.start()
        wait(for: [done], timeout: 30)
    }

    /// 2026-08-13 16:00:00 as a wall time of `tzID` (a real instant).
    private func wallInstant(_ tzID: String) -> Date {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: tzID)!
        return cal.date(from: DateComponents(year: 2026, month: 8, day: 13, hour: 16))!
    }

    // MARK: - Serialize: local wall clock out

    func testFormatRendersTheLocalWallClock() {
        for tzID in ["Europe/Madrid", "Asia/Dubai"] {
            let instant = wallInstant(tzID)
            withTimeZone(tzID) {
                XCTAssertEqual(MCDate.formatDay(instant), "2026-08-13", tzID)
                XCTAssertEqual(MCDate.formatTime(instant), "16:00", tzID)
                XCTAssertEqual(MCDate.formatDateTime(instant), "2026-08-13 16:00", tzID)
                XCTAssertEqual(MCDate.formatDateTimeT(instant), "2026-08-13T16:00", tzID)
                // The formatter DualLinkDB's serialize(fromValue:) uses for every model date.
                XCTAssertEqual(MCDate.dateTimeTFormatter().string(from: instant), "2026-08-13T16:00:00", tzID)
            }
        }
    }

    func testJSONSerializableRendersTheLocalWallClockWithLiteralZ() {
        for tzID in ["Europe/Madrid", "Asia/Dubai"] {
            let instant = wallInstant(tzID)
            withTimeZone(tzID) {
                XCTAssertEqual(MCJSON.serializable(instant) as? String, "2026-08-13T16:00:00Z", tzID)
            }
        }
    }

    // MARK: - Parse: local wall clock in

    func testParseReadsTheStringAsLocalWallClock() {
        for tzID in ["Europe/Madrid", "Asia/Dubai"] {
            let expected = wallInstant(tzID)
            let wall = self.wall
            withTimeZone(tzID) {
                XCTAssertEqual(MCDate.parseOrNil(wall), expected, tzID)
                XCTAssertEqual(MCDate.parseOrNil("2026-08-13T16:00:00"), expected, tzID)
                XCTAssertEqual(MCDate.parseOrNil("2026-08-13T16:00"), expected, tzID)
            }
        }
    }

    /// "No matter what": a zone marker in the incoming string is decoration, not an offset.
    func testParseIgnoresEmbeddedZoneMarkers() {
        for tzID in ["Europe/Madrid", "Asia/Dubai"] {
            let expected = wallInstant(tzID)
            withTimeZone(tzID) {
                XCTAssertEqual(MCDate.parseOrNil("2026-08-13T16:00:00Z"), expected, tzID)
                XCTAssertEqual(MCDate.parseOrNil("2026-08-13T16:00:00.000Z"), expected, tzID)
            }
        }
    }

    // MARK: - The business invariant

    /// parse -> format is the identity on wall-clock strings, whatever the process zone.
    func testRoundTripIsStable() {
        for tzID in ["Europe/Madrid", "Asia/Dubai"] {
            let wall = self.wall
            withTimeZone(tzID) {
                guard let d = MCDate.parseOrNil(wall) else { return XCTFail("parse failed in \(tzID)") }
                XCTAssertEqual(MCDate.dateTimeTFormatter().string(from: d), "2026-08-13T16:00:00", tzID)
                XCTAssertEqual(MCJSON.serializable(d) as? String, "2026-08-13T16:00:00Z", tzID)
            }
        }
    }

    /// A wall-clock string written in one zone reads back as the same wall clock in another:
    /// 16:00 in the Madrid venue's data is still 16:00 when a Dubai process handles it.
    func testWallClockSurvivesATimeZoneHop() {
        var serialized: String?
        withTimeZone("Europe/Madrid") {
            serialized = MCDate.parseOrNil(self.wall).map { MCDate.dateTimeTFormatter().string(from: $0) }
        }
        XCTAssertEqual(serialized, "2026-08-13T16:00:00")

        withTimeZone("Asia/Dubai") {
            guard let s = serialized, let d = MCDate.parseOrNil(s) else { return XCTFail("hop parse failed") }
            XCTAssertEqual(MCDate.formatDateTime(d), "2026-08-13 16:00")
        }
    }

    // MARK: - The explicit-UTC API stays UTC

    func testUTCAPIsAreUnaffectedByTheProcessTimeZone() {
        withTimeZone("Europe/Madrid") {
            let d = MCDate.parseUTC("2026-08-13")
            XCTAssertNotNil(d)
            XCTAssertEqual(MCDate.formatDayUTC(d!), "2026-08-13")
            XCTAssertEqual(d!.timeIntervalSince1970, 1786579200, accuracy: 0.5)  // 2026-08-13T00:00:00Z
        }
    }

    // MARK: - The forced-zone escape hatch (parse in a caller-chosen zone)

    /// `parse(_:in:)` interprets the text in the GIVEN zone, whatever the process zone is —
    /// the deliberate opt-out from the wall-clock default (e.g. force GMT+0).
    func testForcedZoneParseIgnoresTheProcessTimeZone() {
        let utc = TimeZone(secondsFromGMT: 0)!
        let dubai = TimeZone(identifier: "Asia/Dubai")!
        withTimeZone("Europe/Madrid") {
            XCTAssertEqual(MCDate.parseOrNil(self.wall, in: utc)?.timeIntervalSince1970,
                           1786636800, "16:00 forced GMT+0")  // 2026-08-13T16:00:00Z
            XCTAssertEqual(MCDate.parseOrNil(self.wall, in: dubai),
                           self.wallInstant("Asia/Dubai"), "16:00 forced Dubai")
        }
    }

    /// The forced-zone path keeps the same lenient shapes and marker-ignoring as the default engine.
    func testForcedZoneParseKeepsTheEngineSemantics() {
        let utc = TimeZone(secondsFromGMT: 0)!
        withTimeZone("Europe/Madrid") {
            XCTAssertEqual(MCDate.parseOrNil("2026-08-13T16:00:00.000Z", in: utc)?.timeIntervalSince1970, 1786636800)
            XCTAssertEqual(MCDate.parseOrNil("2026-08-13T16:00", in: utc)?.timeIntervalSince1970, 1786636800)
            XCTAssertNil(MCDate.parseOrNil("garbage", in: utc))
            XCTAssertNil(try? MCDate.parse("garbage", in: utc))
        }
    }
}
