//
//  MIOCoreQueue.swift
//
//
//  Created by Javier Segura Perez on 28/8/23.
//

import Foundation

#if !os(WASI)

nonisolated(unsafe) fileprivate var g_mc_queue: [ String: DispatchQueue ] = [:]
nonisolated(unsafe) fileprivate var g_mc_queue_status: [ String: Bool ] = [:]

let main_core_queue = DispatchQueue(label: "com.miolabs.core.main", attributes: .concurrent )

public func MIOCoreQueueRunningInfo( ) -> [String] { return g_mc_queue_status.map { "\($0.key):\($0.value)" } }

public func MIOCoreQueue ( label key: String, prefix:String = "com.miolabs.core" ) -> DispatchQueue
{
    // Makes faster read if the queue exists
    var queue:DispatchQueue? = main_core_queue.sync( ) {
        return g_mc_queue[ key ]
    }
    
    if let q = queue { return q }
    
    main_core_queue.sync( flags: .barrier ) {
        g_mc_queue[ key ] = DispatchQueue(label: "\(prefix).\(key)" )
    }
        
    queue = g_mc_queue[ key ]
    return queue!
}
/*
public func MIOCoreQueueStatus ( label key: String, prefix:String = "com.miolabs.core" ) -> Bool
{
    let status = main_core_queue.sync( ) {
        return g_mc_queue_status[ "\(prefix).\(key)" ] ?? false
    }
    
    return status
}
*/

fileprivate func MIOCoreQueueSetStatus ( value:Bool, label key: String, prefix:String = "com.miolabs.core" )
{
    main_core_queue.sync( flags: .barrier ) {
        if value {
            g_mc_queue_status[ "\(prefix).\(key)" ] = true
        } else {
            // Job complete - clean up both queue and status
            g_mc_queue_status.removeValue(forKey: "\(prefix).\(key)")
            g_mc_queue.removeValue(forKey: key)
        }
    }
}

/// Atomic test-and-set on the queue status. Returns true if the caller
/// acquired (status went from unset → true). Returns false if another
/// caller already holds it.
///
/// Use this instead of the read-then-write pair `MIOCoreQueueStatus` +
/// `MIOCoreQueueSetStatus(value: true, ...)`, which has a TOCTOU gap:
/// two callers can both observe the unset state before either of them
/// writes, and both proceed as if they acquired.
///
/// Pair every successful acquire with exactly one `MIOCoreQueueRelease`,
/// either via `defer` inside the work block or on every early-exit path
/// before the work would have been enqueued.
public func MIOCoreQueueAcquire ( label key: String, prefix:String = "com.miolabs.core" ) -> Bool
{
    return main_core_queue.sync( flags: .barrier ) {
        let fullKey = "\(prefix).\(key)"
        if g_mc_queue_status[ fullKey ] == true {
            return false   // already held by another caller
        }
        g_mc_queue_status[ fullKey ] = true
        return true        // we acquired
    }
}

/// Releases the queue status. Pairs with `MIOCoreQueueAcquire`.
///
/// Equivalent to `MIOCoreQueueSetStatus(value: false, label: ...)` but
/// named to make the acquire/release pairing visible at call sites.
public func MIOCoreQueueRelease ( label key: String, prefix:String = "com.miolabs.core" )
{
    MIOCoreQueueSetStatus( value: false, label: key, prefix: prefix )
}

/// Returns the current cache sizes for monitoring
public func MIOCoreQueueCacheStats() -> (queues: Int, statuses: Int) {
    return main_core_queue.sync {
        return (g_mc_queue.count, g_mc_queue_status.count)
    }
}

#endif
