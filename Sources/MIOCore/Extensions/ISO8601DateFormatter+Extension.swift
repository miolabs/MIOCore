//
//  ISO8601DateFormatter+Extension.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension ISO8601DateFormatter {
    /// Parses an ISO8601 timestamp preserving **microsecond** precision.
    ///
    /// `ISO8601DateFormatter` only understands milliseconds, so this reads the sub-second digits
    /// itself: it pads/truncates the fraction to 6 places, converts to microseconds, and adds them
    /// onto the milliseconds-resolution `Date`. Falls back to the millisecond value when there is no
    /// fractional component.
    ///
    /// ```swift
    /// let d = MCDate.iso8601Formatter().microsecondsDate(from: "2026-07-30T10:00:00.123456Z")
    /// ```
    ///
    /// - Parameter dateString: The ISO8601 timestamp to parse.
    /// - Returns: The `Date` with microsecond precision, or `nil` if the base string cannot be parsed.
    public func microsecondsDate(from dateString: String) -> Date? {
        guard let milliseconds_date = date(from: dateString) else { return nil }
        guard let fraction_index = dateString.lastIndex(of: ".") else { return milliseconds_date }
        let tz_index = dateString.lastIndex(of: "Z")
        let plus_index = dateString.lastIndex(of: "+")
        let last_fraction_index = max(fraction_index, plus_index ?? tz_index ?? dateString.endIndex)

        guard let start_index = dateString.index(fraction_index, offsetBy: 1, limitedBy: last_fraction_index) else { return milliseconds_date }
        // Pad the missing zeros at the end and cut off nanoseconds
        let microseconds_string = dateString[start_index..<last_fraction_index].padding(toLength: 6, withPad: "0", startingAt: 0)
        guard let microseconds = TimeInterval(microseconds_string) else { return milliseconds_date }
        return Date(timeIntervalSince1970: milliseconds_date.timeIntervalSince1970 + microseconds / 1_000_000.0)
    }
}
