//
//  MCRuntime.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// Cross-platform runtime shims: a name→class registry (a portable `NSClassFromString`), class
/// hierarchy lookup and an autorelease-pool wrapper that is a no-op off Apple platforms.
public enum MCRuntime {

    private static let _classes_lock = NSLock()
    private nonisolated(unsafe) static var classesByName: [String: AnyClass] = [:]

    /// Registers a class under a string key for later lookup by ``classFromString(_:)``.
    ///
    /// Backs a portable `NSClassFromString`-style registry: Linux lacks the Objective-C runtime's
    /// string→class resolution, so types that must be instantiated by name (e.g. from a data model)
    /// register themselves here. Thread-safe.
    ///
    /// - Parameters:
    ///   - type: The class to register.
    ///   - key: The string key to register it under (typically the class name).
    public static func registerClass(_ type: AnyClass, forKey key: String) {
        _classes_lock.withLock {
            classesByName[key] = type
        }
    }

    /// Looks up a class previously registered with ``registerClass(_:forKey:)``.
    ///
    /// The cross-platform stand-in for `NSClassFromString`. Thread-safe.
    ///
    /// - Parameter key: The registration key.
    /// - Returns: The registered class, or `nil` if nothing is registered under `key`.
    public static func classFromString(_ key: String) -> AnyClass? {
        _classes_lock.withLock {
            classesByName[key]
        }
    }

    /// The superclass of `type`, or `nil` for a root class.
    ///
    /// The portable `class_getSuperclass`: Swift's documented API has no way to walk a class
    /// hierarchy from a class value. Apple platforms use the Objective-C runtime; Linux and WASI
    /// (no Objective-C runtime) use the standard library's `_getSuperclass`, an underscored
    /// runtime entry point. Keeping the choice here means callers never depend on it directly.
    ///
    /// - Parameter type: Any class (Swift or Objective-C).
    /// - Returns: Its direct superclass, or `nil` when `type` has none.
    public static func superclass(of type: AnyClass) -> AnyClass? {
        #if canImport(ObjectiveC)
        return class_getSuperclass(type)
        #else
        return _getSuperclass(type)
        #endif
    }

    /// `type` followed by each of its superclasses, most specific first.
    ///
    /// - Parameter type: The class to start from.
    /// - Returns: The class chain up to the root class. On Apple platforms a pure-Swift root class
    ///   reports the Swift runtime's internal base class as its superclass, so the chain ends one
    ///   step later there than on Linux / WASI.
    public static func classHierarchy(of type: AnyClass) -> [AnyClass] {
        var chain: [AnyClass] = []
        var current: AnyClass? = type
        while let c = current {
            chain.append(c)
            current = superclass(of: c)
        }
        return chain
    }

    #if os(Linux) || os(WASI)
    /// Runs `body` inside an autorelease pool on Apple platforms; a transparent pass-through elsewhere.
    ///
    /// Lets shared code use pool semantics unconditionally. On Linux/WASI (where there is no
    /// `autoreleasepool`) it simply invokes `body`; on Apple platforms it wraps the call in
    /// `autoreleasepool` so temporary Objective-C objects are drained promptly (e.g. around tight
    /// `DateFormatter` loops, see ``MCDate/parseOrNil(_:)``).
    ///
    /// - Parameter body: The work to execute.
    /// - Returns: Whatever `body` returns.
    /// - Throws: Rethrows any error thrown by `body`.
    public static func autoReleasePool<Result>(invoking body: () throws -> Result) rethrows -> Result { try body() }
    #else
    /// Runs `body` inside an autorelease pool on Apple platforms; a transparent pass-through elsewhere.
    ///
    /// Lets shared code use pool semantics unconditionally. On Linux/WASI (where there is no
    /// `autoreleasepool`) it simply invokes `body`; on Apple platforms it wraps the call in
    /// `autoreleasepool` so temporary Objective-C objects are drained promptly (e.g. around tight
    /// `DateFormatter` loops, see ``MCDate/parseOrNil(_:)``).
    ///
    /// - Parameter body: The work to execute.
    /// - Returns: Whatever `body` returns.
    /// - Throws: Rethrows any error thrown by `body`.
    public static func autoReleasePool<Result>(invoking body: () throws -> Result) rethrows -> Result { try autoreleasepool(invoking: body) }
    #endif
}
