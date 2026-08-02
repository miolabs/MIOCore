//
//  MIOCore.swift
//
//  Created by MIO Research Labs on 31/05/2020.
//

import Foundation

private let _mioCoreClassesLock = NSLock()
private nonisolated(unsafe) var _mioCoreClassesByName: [String: AnyClass] = [:]

/// Registers a class under a string key for later lookup by ``_MIOCoreClassFromString(_:)``.
///
/// Backs a portable `NSClassFromString`-style registry: Linux lacks the Objective-C runtime's
/// string→class resolution, so types that must be instantiated by name (e.g. from a data model)
/// register themselves here. Thread-safe.
///
/// - Parameters:
///   - type: The class to register.
///   - key: The string key to register it under (typically the class name).
public func _MIOCoreRegisterClass( type:AnyClass, forKey key:String ) {
    _mioCoreClassesLock.withLock {
        _mioCoreClassesByName[key] = type
    }
}

/// Looks up a class previously registered with ``_MIOCoreRegisterClass(type:forKey:)``.
///
/// The cross-platform stand-in for `NSClassFromString`. Thread-safe.
///
/// - Parameter key: The registration key.
/// - Returns: The registered class, or `nil` if nothing is registered under `key`.
public func _MIOCoreClassFromString( _ key:String ) -> AnyClass? {
    _mioCoreClassesLock.withLock {
        _mioCoreClassesByName[key]
    }
}

#if os(Linux) || os(WASI)
/// Runs `body` inside an autorelease pool on Apple platforms; a transparent pass-through elsewhere.
///
/// Lets shared code use pool semantics unconditionally. On Linux/WASI (where there is no
/// `autoreleasepool`) it simply invokes `body`; on Apple platforms it wraps the call in
/// `autoreleasepool` so temporary Objective-C objects are drained promptly (e.g. around tight
/// `DateFormatter` loops, see ``MIOCoreDate(fromString:)``).
///
/// - Parameter body: The work to execute.
/// - Returns: Whatever `body` returns.
/// - Throws: Rethrows any error thrown by `body`.
public func MIOCoreAutoReleasePool<Result>(invoking body: () throws -> Result) rethrows -> Result { try body() }
#else
/// Runs `body` inside an autorelease pool on Apple platforms; a transparent pass-through elsewhere.
///
/// Lets shared code use pool semantics unconditionally. On Linux/WASI (where there is no
/// `autoreleasepool`) it simply invokes `body`; on Apple platforms it wraps the call in
/// `autoreleasepool` so temporary Objective-C objects are drained promptly (e.g. around tight
/// `DateFormatter` loops, see ``MIOCoreDate(fromString:)``).
///
/// - Parameter body: The work to execute.
/// - Returns: Whatever `body` returns.
/// - Throws: Rethrows any error thrown by `body`.
public func MIOCoreAutoReleasePool<Result>(invoking body: () throws -> Result) rethrows -> Result { try autoreleasepool(invoking: body) }
#endif
