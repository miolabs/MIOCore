//
//  MCDate+Formatters.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

extension MCDate {

    /// The library's thread-cached date formatters, one per recognized pattern.
    ///
    /// `DateFormatter`/`ISO8601DateFormatter` are expensive and not thread-safe, so each is kept as a
    /// single per-thread instance. Reach them through ``MCDate``'s parse/format entry points and the
    /// public accessors below, not directly.
    enum Formatters {

        // MARK: - Per-pattern factories

        /// Local `yyyy-MM-dd`.
        static func date() -> DateFormatter { _cached("date") { _make("yyyy-MM-dd", .current) } as! DateFormatter }

        /// Local `HH:mm`.
        static func time() -> DateFormatter { _cached("time") { _make("HH:mm", .current) } as! DateFormatter }

        /// Local `yyyy-MM-dd HH:mm`.
        static func dateTime() -> DateFormatter { _cached("dateTime") { _make("yyyy-MM-dd HH:mm", .current) } as! DateFormatter }

        /// Local `yyyy-MM-dd'T'HH:mm`.
        static func dateTimeT() -> DateFormatter { _cached("dateTimeT") { _make("yyyy-MM-dd'T'HH:mm", .current) } as! DateFormatter }

        /// Local `yyyy-MM-dd'T'HH:mm:ss`.
        static func dateTimeTS() -> DateFormatter { _cached("dateTimeTS") { _make("yyyy-MM-dd'T'HH:mm:ss", .current) } as! DateFormatter }

        /// `en_US_POSIX` `yyyy-MM-dd HH:mm:ss` (the primary parse format).
        static func dateTimeS() -> DateFormatter { _cached("dateTimeS") { _make("yyyy-MM-dd HH:mm:ss", _posix) } as! DateFormatter }

        /// Local `yyyy-MM-dd'T'HH:mm:ss'Z'` (a literal `Z`, not a zone specifier).
        static func z() -> DateFormatter { _cached("z") { _make("yyyy-MM-dd'T'HH:mm:ss'Z'", .current) } as! DateFormatter }

        /// A cached UTC `DateFormatter` (`en_US_POSIX`, no fixed pattern).
        static func utc() -> DateFormatter { _cached("utc") { MCDate.makeUTCFormatter() } as! DateFormatter }

        /// `ISO8601DateFormatter` with internet date-time and fractional seconds.
        static func iso() -> ISO8601DateFormatter {
            _cached("iso") {
                let df = ISO8601DateFormatter()
                df.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                return df
            } as! ISO8601DateFormatter
        }

        // MARK: - Shared building blocks

        private static let _posix = Locale(identifier: "en_US_POSIX")

        /// Builds a `DateFormatter` with the given pattern and locale.
        private static func _make(_ format: String, _ locale: Locale) -> DateFormatter {
            let df = DateFormatter()
            df.locale = locale
            df.dateFormat = format
            return df
        }

        /// Returns the thread-cached `Formatter` for `key`, building it via `factory` on first use.
        ///
        /// `DateFormatter`/`ISO8601DateFormatter` aren't thread-safe, so one instance is kept per
        /// thread (a shared global on single-threaded WASI). `key` is namespaced so it can't collide
        /// with other users of `Thread.current.threadDictionary`.
        #if os(WASI)
        // WASI is single-threaded: a plain global cache is safe.
        nonisolated(unsafe) private static var _wasi_cache: [String: Formatter] = [:]
        private static func _cached(_ key: String, factory: () -> Formatter) -> Formatter {
            let namespaced = "MCDate.Formatters.\(key)"
            if let df = _wasi_cache[namespaced] { return df }
            let df = factory()
            _wasi_cache[namespaced] = df
            return df
        }
        #else
        private static func _cached(_ key: String, factory: () -> Formatter) -> Formatter {
            let namespaced = "MCDate.Formatters.\(key)"
            let dict = Thread.current.threadDictionary
            if let df = dict[namespaced] as? Formatter { return df }
            let df = factory()
            dict[namespaced] = df
            return df
        }
        #endif
    }
}

// MARK: - Public formatter accessors

extension MCDate {

    /// Returns a thread-cached `DateFormatter` fixed to `en_US_POSIX` and UTC.
    ///
    /// Formatters are expensive and not thread-safe, so one instance is cached per thread. Use this
    /// for stable, locale-independent formatting that behaves identically on Apple platforms and Linux.
    ///
    /// - Returns: The per-thread UTC `DateFormatter`.
    public static func utcFormatter() -> DateFormatter { Formatters.utc() }

    /// Creates a fresh `DateFormatter` fixed to UTC, with `en_US_POSIX` by default.
    ///
    /// Unlike ``utcFormatter()``, this allocates a new instance each call. Use it when you need to set
    /// a custom `dateFormat` without mutating the shared per-thread formatter. Pass `locale: nil` to
    /// leave the locale at the device default (as ``formatTimeUTC(_:)`` does).
    ///
    /// - Parameter locale: The locale to apply, or `nil` to leave it unset. Defaults to `en_US_POSIX`.
    /// - Returns: A newly created UTC `DateFormatter`.
    public static func makeUTCFormatter(locale: Locale? = Locale(identifier: "en_US_POSIX")) -> DateFormatter {
        let df = DateFormatter()
        if let locale { df.locale = locale }
        df.timeZone = TimeZone(secondsFromGMT: 0)
        return df
    }

    /// Returns a thread-cached `ISO8601DateFormatter` with internet date-time and fractional seconds.
    ///
    /// Configured with `[.withInternetDateTime, .withFractionalSeconds]`, the format used for
    /// timestamps exchanged with the server and DB.
    ///
    /// - Returns: The per-thread ISO8601 formatter.
    public static func iso8601Formatter() -> ISO8601DateFormatter { Formatters.iso() }

    /// Returns a thread-cached `DateFormatter` for the local `yyyy-MM-dd'T'HH:mm:ss` pattern.
    ///
    /// - Returns: The per-thread `T`-separated date-time formatter (with seconds).
    public static func dateTimeTFormatter() -> DateFormatter { Formatters.dateTimeTS() }
}
