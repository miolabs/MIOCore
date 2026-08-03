//
//  MCQueue.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

#if !os(WASI)

/// A registry of named, cached serial `DispatchQueue`s with cooperative acquire/release.
///
/// Queues are memoized by label (``named(_:prefix:)``); ``acquire(_:prefix:)`` and
/// ``release(_:prefix:)`` provide an atomic test-and-set so only one caller runs a labeled job at a
/// time. Not available on WASI (single-threaded).
public enum MCQueue {

    nonisolated(unsafe) fileprivate static var queues: [String: DispatchQueue] = [:]
    nonisolated(unsafe) fileprivate static var queue_statuses: [String: Bool] = [:]

    fileprivate static let coordinator = DispatchQueue(label: "com.miolabs.core.main", attributes: .concurrent)

    fileprivate static func setStatus(value: Bool, label key: String, prefix: String = "com.miolabs.core") {
        coordinator.sync(flags: .barrier) {
            if value {
                queue_statuses["\(prefix).\(key)"] = true
            } else {
                // Job complete - clean up both queue and status
                queue_statuses.removeValue(forKey: "\(prefix).\(key)")
                queues.removeValue(forKey: key)
            }
        }
    }

    /// Returns a snapshot of the queue-status registry as `"fullKey:held"` strings, for debugging.
    ///
    /// - Returns: One entry per tracked status key.
    public static func runningInfo() -> [String] { queue_statuses.map { "\($0.key):\($0.value)" } }

    /// Returns a named, cached serial `DispatchQueue`, creating it on first use.
    ///
    /// Queues are memoized by `key`, so repeated calls with the same key return the same instance.
    /// Lookup/creation is coordinated through an internal concurrent queue for thread safety.
    ///
    /// - Parameters:
    ///   - key: The queue label (memoization key).
    ///   - prefix: A reverse-DNS prefix for the underlying queue's label. Defaults to `"com.miolabs.core"`.
    /// - Returns: The cached (or newly created) serial queue.
    public static func named(_ key: String, prefix: String = "com.miolabs.core") -> DispatchQueue {
        // Makes faster read if the queue exists
        var queue: DispatchQueue? = coordinator.sync {
            queues[key]
        }

        if let q = queue { return q }

        coordinator.sync(flags: .barrier) {
            queues[key] = DispatchQueue(label: "\(prefix).\(key)")
        }

        queue = queues[key]
        return queue!
    }

    /// Atomic test-and-set on the queue status. Returns true if the caller
    /// acquired (status went from unset → true). Returns false if another
    /// caller already holds it.
    ///
    /// Use this instead of a read-then-write status pair, which has a TOCTOU gap:
    /// two callers can both observe the unset state before either of them
    /// writes, and both proceed as if they acquired.
    ///
    /// Pair every successful acquire with exactly one ``release(_:prefix:)``,
    /// either via `defer` inside the work block or on every early-exit path
    /// before the work would have been enqueued.
    public static func acquire(_ key: String, prefix: String = "com.miolabs.core") -> Bool {
        coordinator.sync(flags: .barrier) {
            let fullKey = "\(prefix).\(key)"
            if queue_statuses[fullKey] == true {
                return false  // already held by another caller
            }
            queue_statuses[fullKey] = true
            return true  // we acquired
        }
    }

    /// Releases the queue status. Pairs with ``acquire(_:prefix:)``.
    ///
    /// Named to make the acquire/release pairing visible at call sites.
    public static func release(_ key: String, prefix: String = "com.miolabs.core") {
        setStatus(value: false, label: key, prefix: prefix)
    }

    /// Returns the current cache sizes for monitoring
    public static func cacheStats() -> (queues: Int, queue_statuses: Int) {
        coordinator.sync {
            (queues.count, queue_statuses.count)
        }
    }
}

#endif
