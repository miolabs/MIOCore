//
//  MIOCoreLogger.swift
//
//  Created by MIO Research Labs on 17/08/2024.
//

import Foundation
import MIOCore
@_exported import Logging


extension String
{
    func camelCase() -> String {
        return unicodeScalars.dropFirst().reduce(String(prefix(1))) {
            return CharacterSet.uppercaseLetters.contains($1)
                    ? $0 + "-" + String($1)
                    : $0 + String($1)
        }
    }
}


// Thread-safe, non-actor registry with tiny per-file cache
final class LoggerRegistry: @unchecked Sendable {
    struct Entry { var logger: Logger; var level: Logger.Level }

    static let shared = LoggerRegistry()

#if os(WASI)
    // WASI is single-threaded: no Dispatch available, execute bodies inline
    private struct QueueShim {
        enum Flags { case barrier }
        func sync<T>(execute body: () -> T) -> T { body() }
        func sync<T>(flags: Flags, execute body: () -> T) -> T { body() }
    }
    private let q = QueueShim()
#else
    private let q = DispatchQueue(label: "com.duallink.logger.registry", attributes: .concurrent)
#endif
    private var cache: [String: Entry] = [:]
        
    private init() {}
    
    // Normalize file path: drop extension and convert path separators to dots, e.g. Sources/Foo/Bar.swift -> Sources.Foo.Bar
    private func normalizedLabel(from file: String) -> String {
        var path = file
        // remove last extension if any
        if let dotIndex = file.utf8.lastIndex(of: UInt8(ascii: ".")) {
            let noExt = String(file[..<dotIndex])
            path = noExt
        }
    
        return path.replacingOccurrences(of: "/", with: "_")
    }

    // Resolve log level from environment variables, walking label components like: Module_Sub_A_B_LogLevel
    private func configuredLevel(for label: String) -> Logger.Level {
        var levelStr: String? = nil
        let components = label.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "_")
        var probe = components
        while probe.isEmpty == false {
            let key = (probe.joined(separator: "_") + "_LogLevel").lowercased()
            if let v = MCEnvironmentVar(key)?.lowercased() { levelStr = v.trimmingCharacters(in: .whitespacesAndNewlines); break }
            probe = probe.dropLast()
        }
        
        switch levelStr {
        case "trace"   : return .trace
        case "debug"   : return .debug
        case "info"    : return .info
        case "notice"  : return .notice
        case "warning" : return .warning
        case "error"   : return .error
        case "critical": return .critical
        default        : return .info
        }
    }    
    
    private func makeEntry(label: String) -> Entry {
        let lvl = configuredLevel(for: label)
        var l = Logger(label: label)
        l.logLevel = lvl
        return Entry(logger: l, level: lvl)
    }
    
    
    private func entry(for label: String) -> Entry {
        // Fast read path
        if let e = q.sync(execute: { cache[label] }) { return e }
        // Create and store synchronously with a barrier so all threads see it immediately
        let created = makeEntry(label: label)
        q.sync(flags: .barrier) { cache[label] = created }
        return created
    }

    // Main logging function with lazy message; short-circuits by level without evaluating the message
    func log(
        level: Logger.Level,
        _ message: () -> Logger.Message,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
    
        let label = normalizedLabel(from: file)
        let e = entry(for: label)
        // Fast path: if requested level is below configured threshold, do nothing and DO NOT evaluate message()
        guard level >= e.level else { return }
        e.logger.log(level: level, message(), file: file, function: function, line: line)
    }

    // Create/return a custom logger obeying the same cached level
    func newCustomLogger(_ label: String) -> Logger {
        if let e = q.sync(execute: { cache[label] }) { return e.logger }
        let created = makeEntry(label: label)
        q.sync(flags: .barrier) { cache[label] = created }
        return created.logger
    }
}

let loggers = LoggerRegistry.shared

/// A leveled logging front door, a thin, uniform wrapper over swift-log.
///
/// Application and library code logs through `Log` instead of `print`, so output is consistent and
/// level-filtered. Each call captures `#fileID`/`#function`/`#line` automatically, and
/// the message is an `@autoclosure`, it is only built when the level is enabled, so disabled log
/// statements cost nothing. The logger label is derived from the calling file, and its level can be
/// set per module/path via environment variables (e.g. `MyModule_LogLevel=debug`).
///
/// ```swift
/// import MIOCoreLogger
///
/// Log.info("Server listening on :\(port)")
/// Log.error("Render failed: \(error.localizedDescription)")
/// ```
public final class Log
{
    static func log(level: Logger.Level,
                    _ message: () -> Logger.Message,
                    file: String = #fileID,
                    function: String = #function,
                    line: UInt = #line) {
        loggers.log(level: level, message, file: file, function: function, line: line)
    }

    /// Logs a message at the `trace` level (most verbose).
    static public func trace(_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log(level: .trace, message, file: file, function: function, line: line) }
    /// Logs a message at the `debug` level.
    static public func debug(_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log(level: .debug, message, file: file, function: function, line: line) }
    /// Logs a message at the `info` level (the default threshold).
    static public func info(_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log(level: .info, message, file: file, function: function, line: line) }
    /// Logs a message at the `notice` level.
    static public func notice(_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log(level: .notice, message, file: file, function: function, line: line) }
    /// Logs a message at the `warning` level.
    static public func warning(_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log(level: .warning, message, file: file, function: function, line: line) }
    /// Logs a message at the `error` level.
    static public func error(_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log(level: .error, message, file: file, function: function, line: line) }
    /// Logs a message at the `critical` level (most severe).
    static public func critical(_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log(level: .critical, message, file: file, function: function, line: line) }
}

