//
//  MIOCoreContext+UserDefaults.swift
//
//
//  Created by Javier Segura Perez on 22/11/23.
//

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)

import Foundation


/// A property wrapper that backs a non-optional value in `UserDefaults`.
///
/// Reads fall back to `defaultValue` when the key is absent or the stored type doesn't match; writes
/// persist to `UserDefaults.standard`. Apple platforms only.
///
/// ```swift
/// @ContextUserDefaultVar(key: "launchCount", defaultValue: 0) var launchCount: Int
/// ```
@propertyWrapper
public struct ContextUserDefaultVar<Value>
{
    let key:String
    let default_value:Value

    /// The stored value, read from / written to `UserDefaults.standard`.
    public var wrappedValue: Value {
        get { return UserDefaults.standard.value( forKey: key ) as? Value ?? default_value }
        set { UserDefaults.standard.setValue( newValue, forKey: key ) }
    }

    /// Creates the wrapper for a given key and default.
    ///
    /// - Parameters:
    ///   - key: The `UserDefaults` key.
    ///   - defaultValue: The value returned when the key is missing.
    public init( key:String, defaultValue:Value ) {
        self.key = key
        self.default_value = defaultValue
    }
}

/// A property wrapper that backs an **optional** value in `UserDefaults`.
///
/// The optional counterpart of ``ContextUserDefaultVar``, `defaultValue` defaults to `nil`. Apple
/// platforms only.
@propertyWrapper
public struct ContextUserDefaultOptionalVar<Value>
{
    let key:String
    let default_value:Value?

    /// The stored optional value, read from / written to `UserDefaults.standard`.
    public var wrappedValue: Value? {
        get { return UserDefaults.standard.value( forKey: key ) as? Value ?? default_value }
        set { UserDefaults.standard.setValue( newValue, forKey: key ) }
    }

    /// Creates the wrapper for a given key and optional default.
    ///
    /// - Parameters:
    ///   - key: The `UserDefaults` key.
    ///   - defaultValue: The value returned when the key is missing. Defaults to `nil`.
    public init( key:String, defaultValue:Value? = nil ) {
        self.key = key
        self.default_value = defaultValue
    }
}

#endif
