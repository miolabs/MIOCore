//
//  MCDate.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// Parses and formats dates, cross-platform and identical on Apple platforms and Linux.
///
/// Two timezone regimes, made explicit by the member names:
///
/// - **Local** (device time via `Locale.current`): ``parse(_:)`` / ``parseOrNil(_:)`` (multi-format),
///   ``parseTime(_:)`` / ``parseTimeOrNil(_:)``, and the `format...` day/time entry points.
/// - **UTC** (fixed zero offset, no daylight saving): ``parseUTC(_:)``, ``formatDayUTC(_:)``,
///   ``formatTimeUTC(_:)``, and the ``utcFormatter()`` / ``makeUTCFormatter(locale:)`` accessors.
///
/// ``parse(_:)`` and ``parseOrNil(_:)`` are the throwing/non-throwing pair over the same local
/// multi-format engine; ``parseTime(_:)`` and ``parseTimeOrNil(_:)`` are the same for `HH:mm`.
public enum MCDate {

    /// The ISO8601 options for a bare `yyyy-MM-dd` UTC date, shared by ``parseUTC(_:)`` and
    /// ``formatDayUTC(_:)``.
    private static let _iso_date_only_options: ISO8601DateFormatter.Options = [
        .withYear, .withMonth, .withDay, .withDashSeparatorInDate,
    ]

    /// Parses a date string with the local multi-format engine, throwing if nothing matches.
    ///
    /// The throwing companion of ``parseOrNil(_:)``.
    ///
    /// - Parameter string: The textual date to parse.
    /// - Returns: The parsed `Date`.
    /// - Throws: ``MCError/general(_:functionName:)`` if no known format matches.
    public static func parse(_ string: String) throws -> Date {
        let ret = MCDate.parseOrNil(string)

        if ret == nil {
            throw MCError.general("Could not parse date >>\(string)<<")
        }

        #if DEBUG
        return ret!
        //        return ret!.addingTimeInterval( 60 * 60 * 2)
        #else
        return ret!
        #endif
    }

    /// Parses a date string by trying every local date/time format this library recognizes, returning `nil` on failure.
    ///
    /// Attempts, in likelihood order: `yyyy-MM-dd HH:mm:ss` (POSIX), `yyyy-MM-dd`, `yyyy-MM-dd HH:mm`,
    /// and the `'T'`/`'T'...ss`/`'Z'` variants. As a last resort it strips fractional seconds, trims to
    /// 19 characters, and even retries with a one-hour shift, all length-guarded so a short,
    /// unparseable string returns `nil` rather than trapping. This is the engine behind ``parse(_:)``.
    ///
    /// - Parameter string: The textual date to parse.
    /// - Returns: The parsed `Date`, or `nil` if no format matches.
    public static func parseOrNil(_ string: String) -> Date? {
        var date: Date?
        MCRuntime.autoReleasePool {

            var df: DateFormatter

            // Most probably case
            df = Formatters.dateTimeS()
            if let ret = df.date(from: string) {
                date = ret
                return
            }

            // Check other cases
            df = Formatters.date()
            if let ret = df.date(from: string) {
                date = ret
                return
            }

            df = Formatters.dateTime()
            if let ret = df.date(from: string) {
                date = ret
                return
            }

            df = Formatters.dateTimeT()
            if let ret = df.date(from: string) {
                date = ret
                return
            }

            df = Formatters.dateTimeTS()
            if let ret = df.date(from: string) {
                date = ret
                return
            }

            df = Formatters.z()
            if let ret = df.date(from: string) {
                date = ret
                return
            }

            // Last-resort attempts slice fixed character ranges. Guard the length
            // so an unparseable short string returns nil instead of trapping.
            guard let rm_ms = string.split(separator: ".").first else { return }
            var last_try = String(rm_ms).replacingOccurrences(of: "T", with: " ")

            if last_try.count > 19 {
                last_try = String(last_try[..<last_try.index(last_try.startIndex, offsetBy: 19)])

            }

            df = Formatters.dateTimeS()
            if let ret = df.date(from: last_try) {
                date = ret
                return
            }

            //df = Formatters.dateTimeS()
            //if let ret = df.date(from: last_try ) { date = ret; return }

            // Check for a timeshift
            guard last_try.count >= 13 else { return }
            let r = last_try.index(last_try.startIndex, offsetBy: 11)..<last_try.index(last_try.startIndex, offsetBy: 13)
            let hh = String(last_try[r])
            var h = MCCast.int(hh, default: 0)!
            h -= 1
            last_try.replaceSubrange(r, with: String(format: "%02i", h))

            if let ret = df.date(from: last_try) {
                date = ret
                return
            }
        }

        return date
    }

    /// Parses an `HH:mm` time string (local), throwing if it cannot be understood.
    ///
    /// The throwing companion of ``parseTimeOrNil(_:)``.
    ///
    /// - Parameter string: The textual time to parse (`HH:mm`).
    /// - Returns: The parsed `Date` (on the formatter's reference day).
    /// - Throws: ``MCError/general(_:functionName:)`` if the string cannot be parsed.
    public static func parseTime(_ string: String) throws -> Date {
        let ret = Formatters.time().date(from: string)

        if ret == nil {
            throw MCError.general("Time >>\(string)<< could not be parsed")
        }

        return ret!
    }

    /// Parses an `HH:mm` time string (local), returning `nil` instead of throwing on failure.
    ///
    /// - Parameter string: The textual time to parse (`HH:mm`).
    /// - Returns: The parsed `Date`, or `nil` if it cannot be parsed.
    public static func parseTimeOrNil(_ string: String) -> Date? {
        Formatters.time().date(from: string)
    }

    /// Formats a `Date` as a local `yyyy-MM-dd` day string.
    ///
    /// - Parameter date: The date to format.
    /// - Returns: The date rendered as `yyyy-MM-dd`.
    public static func formatDay(_ date: Date) -> String {
        Formatters.date().string(from: date)
    }

    /// Formats a `Date` as a local `HH:mm` time-of-day string.
    ///
    /// - Parameter date: The date whose time component to format.
    /// - Returns: The time rendered as `HH:mm`.
    public static func formatTime(_ date: Date) -> String {
        Formatters.time().string(from: date)
    }

    /// Formats a `Date` as a local `yyyy-MM-dd HH:mm` string (space separator).
    ///
    /// - Parameter date: The date to format.
    /// - Returns: The date rendered as `yyyy-MM-dd HH:mm`.
    public static func formatDateTime(_ date: Date) -> String {
        Formatters.dateTime().string(from: date)
    }

    /// Formats a `Date` as a local `yyyy-MM-dd'T'HH:mm` string (`T` separator).
    ///
    /// The `T`-separated counterpart of ``formatDateTime(_:)``.
    ///
    /// - Parameter date: The date to format.
    /// - Returns: The date rendered as `yyyy-MM-dd'T'HH:mm`.
    public static func formatDateTimeT(_ date: Date) -> String {
        Formatters.dateTimeT().string(from: date)
    }

    /// Parses an ISO8601 date/date-time string as UTC, adapting options to the string's shape.
    ///
    /// Handles a bare `yyyy-MM-dd` (length 10), a space- or `T`-separated date-time, and a minute-only
    /// time (length 16, to which `:00` seconds are appended) by toggling `ISO8601DateFormatter.Options`
    /// accordingly.
    ///
    /// - Parameter string: The ISO8601 date or date-time string.
    /// - Returns: The parsed `Date`, or `nil` if it does not match.
    public static func parseUTC(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        var date_str = string

        var options = MCDate._iso_date_only_options

        if string.count == 10 {
            formatter.formatOptions = options
            return formatter.date(from: date_str)
        }

        if !string.contains("T") { options.insert(.withSpaceBetweenDateAndTime) }
        if string.count == 16 { date_str += ":00" }

        options.insert([.withTime, .withColonSeparatorInTime])
        formatter.formatOptions = options
        return formatter.date(from: date_str)
    }

    /// Formats a `Date` as a `yyyy-MM-dd` day string in UTC (stable across platforms).
    ///
    /// ```swift
    /// let s = MCDate.formatDayUTC(date)   // e.g. "2026-07-30"
    /// ```
    ///
    /// - Parameter date: The date to format.
    /// - Returns: The UTC day string.
    public static func formatDayUTC(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = MCDate._iso_date_only_options
        return formatter.string(from: date)
    }

    /// Formats a `Date` as an `HH:mm` time-of-day string in UTC.
    ///
    /// - Parameter date: The date whose time component to format.
    /// - Returns: The UTC `HH:mm` string.
    public static func formatTimeUTC(_ date: Date) -> String {
        let df = makeUTCFormatter(locale: nil)
        df.dateFormat = "HH:mm"
        return df.string(from: date)
    }
}
