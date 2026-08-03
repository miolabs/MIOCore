//
//  Deprecated+Date.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous date parse/format signatures. Use MCDate instead. Kept as forwards so downstream keeps building.
//
//  Heads up on the renames: the old names half-hid local vs UTC and implied a throwing pair that
//  didn't exist. parse_date / MIOCoreDate(fromString:) are the local pair (now MCDate.parse / parseOrNil);
//  parse_date_or_nil was actually a nil-tolerant UTC parse (now MCDate.parseUTC). The old "GMT0"
//  names are just UTC (GMT+0), now spelled ...UTC in MCDate.
//

import Foundation

// MARK: - Local parse / format

@available(*, deprecated, renamed: "MCDate.parse(_:)")
public func parse_date(_ dateString: String) throws -> Date {
    try MCDate.parse(dateString)
}

@available(*, deprecated, renamed: "MCDate.parseOrNil(_:)")
public func MIOCoreDate(fromString dateString: String) -> Date? {
    MCDate.parseOrNil(dateString)
}

@available(*, deprecated, renamed: "MCDate.parseTime(_:)")
public func parse_time(_ time: String) throws -> Date {
    try MCDate.parseTime(time)
}

@available(*, deprecated, renamed: "MCDate.parseTimeOrNil(_:)")
public func parse_time_or_nil(_ time: String) -> Date? {
    MCDate.parseTimeOrNil(time)
}

@available(*, deprecated, renamed: "MCDate.formatDay(_:)")
public func format_date(_ date: Date) -> String {
    MCDate.formatDay(date)
}

@available(*, deprecated, renamed: "MCDate.formatTime(_:)")
public func format_time(_ date: Date) -> String {
    MCDate.formatTime(date)
}

@available(*, deprecated, renamed: "MCDate.formatDateTime(_:)")
public func format_date_time(_ date: Date) -> String {
    MCDate.formatDateTime(date)
}

@available(*, deprecated, renamed: "MCDate.formatDateTimeT(_:)")
public func format_date_time_t(_ date: Date) -> String {
    MCDate.formatDateTimeT(date)
}

// MARK: - UTC parse / format

@available(*, deprecated, renamed: "MCDate.parseUTC(_:)")
public func parse_date_or_nil(_ dateString: String?) -> Date? {
    dateString == nil ? nil : MCDate.parseUTC(dateString!)
}

@available(*, deprecated, renamed: "MCDate.parseUTC(_:)")
public func MCDateGMT0Parser(_ string: String) -> Date? {
    MCDate.parseUTC(string)
}

@available(*, deprecated, renamed: "MCDate.formatDayUTC(_:)")
public func MCDateGMT0Format(_ date: Date) -> String {
    MCDate.formatDayUTC(date)
}

@available(*, deprecated, renamed: "MCDate.formatTimeUTC(_:)")
public func MCTimeGMT0Format(_ date: Date) -> String {
    MCDate.formatTimeUTC(date)
}

// MARK: - Formatter accessors

@available(*, deprecated, renamed: "MCDate.utcFormatter()")
public func dateFormaterInGMT0() -> DateFormatter {
    MCDate.utcFormatter()
}

@available(*, deprecated, renamed: "MCDate.utcFormatter()")
public func MIOCoreDateGMT0Formatter() -> DateFormatter {
    MCDate.utcFormatter()
}

@available(*, deprecated, renamed: "MCDate.makeUTCFormatter()")
public func MIOCoreDateCreateGMT0Formatter() -> DateFormatter {
    MCDate.makeUTCFormatter()
}

@available(*, deprecated, renamed: "MCDate.iso8601Formatter()")
public func MIOCoreISO8601Formatter() -> ISO8601DateFormatter {
    MCDate.iso8601Formatter()
}

@available(*, deprecated, renamed: "MCDate.dateTimeTFormatter()")
public func MIOCoreDateTDateTimeFormatter() -> DateFormatter {
    MCDate.dateTimeTFormatter()
}
