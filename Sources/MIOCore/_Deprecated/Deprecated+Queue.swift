//
//  Deprecated+Queue.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous named-queue signatures. Use MCQueue instead. Kept as forwards so downstream keeps building.
//

import Foundation

#if !os(WASI)

@available(*, deprecated, renamed: "MCQueue.named(_:prefix:)")
public func MIOCoreQueue(label key: String, prefix: String = "com.miolabs.core") -> DispatchQueue {
    MCQueue.named(key, prefix: prefix)
}

@available(*, deprecated, renamed: "MCQueue.acquire(_:prefix:)")
public func MIOCoreQueueAcquire(label key: String, prefix: String = "com.miolabs.core") -> Bool {
    MCQueue.acquire(key, prefix: prefix)
}

@available(*, deprecated, renamed: "MCQueue.release(_:prefix:)")
public func MIOCoreQueueRelease(label key: String, prefix: String = "com.miolabs.core") {
    MCQueue.release(key, prefix: prefix)
}

@available(*, deprecated, renamed: "MCQueue.runningInfo()")
public func MIOCoreQueueRunningInfo() -> [String] {
    MCQueue.runningInfo()
}

@available(*, deprecated, renamed: "MCQueue.cacheStats()")
public func MIOCoreQueueCacheStats() -> (queues: Int, queue_statuses: Int) {
    MCQueue.cacheStats()
}

#endif
