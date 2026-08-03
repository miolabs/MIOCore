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
        guard let millisecondsDate = date(from: dateString) else { return nil }
        guard let fractionIndex = dateString.lastIndex(of: ".") else { return millisecondsDate }
        let tzIndex = dateString.lastIndex(of: "Z")
        let plusIndex = dateString.lastIndex(of: "+")
        let lastFractionIndex = max(fractionIndex, plusIndex ?? tzIndex ?? dateString.endIndex)

        guard let startIndex = dateString.index(fractionIndex, offsetBy: 1, limitedBy: lastFractionIndex) else { return millisecondsDate }
        // Pad the missing zeros at the end and cut off nanoseconds
        let microsecondsString = dateString[startIndex..<lastFractionIndex].padding(toLength: 6, withPad: "0", startingAt: 0)
        guard let microseconds = TimeInterval(microsecondsString) else { return millisecondsDate }
        return Date(timeIntervalSince1970: millisecondsDate.timeIntervalSince1970 + microseconds / 1_000_000.0)
    }
}
