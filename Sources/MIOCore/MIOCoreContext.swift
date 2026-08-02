//
//  MIOCoreContext.swift
//
//  Created by MIO Research Labs on 16/11/2023.
//

import Foundation

//@attached(accessor)
//public macro ContextVar() = #externalMacro( module: "MIOCoreContextMacros", type: "ContextVarMacro" )

/// A type that carries a bag of process- or request-scoped global values.
///
/// The abstraction lets shared code read/write contextual state (the current tenant, request user,
/// feature flags, …) without hard-wiring a concrete storage mechanism. ``MIOCoreContext`` is the
/// standard implementation.
public protocol MIOCoreContextProtocol
{
    /// The backing dictionary of global values, keyed by name.
    var globals: [ String: Any ] { get set }

//    func setGlobalValue ( _ value: Any, forKey key: String )
//    func removeGlobalValue ( forKey key: String )
//    func sendableValues() -> [String:(any Sendable)]
}

/// A thread-safe container for process/request globals.
///
/// All access to ``globals`` is guarded by an internal lock, so instances are safe to share across
/// threads (the class is `nonisolated` and subclassable via `open`). Values added through the
/// `Sendable` overload of `setGlobalValue(_:forKey:)` are additionally tracked and returned by
/// ``sendableValues()`` for hand-off across concurrency boundaries.
nonisolated open class MIOCoreContext : NSObject, MIOCoreContextProtocol
{
    private let lock = NSLock()
    private var _globals:[ String: Any ] = [:]
    private var _sendable_globals:[ String:(any Sendable)] = [:]
    
    /// The current globals as a dictionary. Reads and writes are lock-guarded.
    public var globals: [ String: Any ] {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _globals
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _globals = newValue
        }
    }

    /// Creates a context pre-populated with the given globals.
    ///
    /// - Parameter values: Initial key/value globals. Defaults to empty.
    public init ( _ values: [String:Any] = [:] ) {
        super.init( )
        for (key, value) in values {
            setGlobalValue( value, forKey: key )
        }
    }

    /// Sets a global value for a key (thread-safe).
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to store it under.
    public func setGlobalValue ( _ value: Any, forKey key: String )
    {
        lock.lock()
        defer { lock.unlock() }
        _globals[key] = value
    }

    /// Sets a `Sendable` global value, also recording it for ``sendableValues()``.
    ///
    /// Prefer this overload for values you intend to carry across concurrency boundaries.
    ///
    /// - Parameters:
    ///   - value: The `Sendable` value to store.
    ///   - key: The key to store it under.
    public func setGlobalValue ( _ value: any Sendable, forKey key: String )
    {
        lock.lock()
        defer { lock.unlock() }
        _globals[key] = value
        _sendable_globals[key] = value
    }

    
    /// Removes the global value for a key from both the general and `Sendable` stores (thread-safe).
    ///
    /// - Parameter key: The key to remove.
    public func removeGlobalValue ( forKey key: String )
    {
        lock.lock()
        defer { lock.unlock() }
        _globals.removeValue( forKey: key )
        _sendable_globals.removeValue(forKey: key)
    }

    /// Returns a snapshot of the values that were stored as `Sendable`.
    ///
    /// Override in a subclass to customize what crosses concurrency boundaries.
    ///
    /// - Returns: The `Sendable` globals, keyed by name.
    open func sendableValues() -> [String:(any Sendable)] {
        lock.lock()
        defer { lock.unlock() }
        return _sendable_globals
    }
}
