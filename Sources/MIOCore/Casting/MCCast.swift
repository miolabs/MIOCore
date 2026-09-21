//
//  MCCast.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// Lenient coercion of `Any?` into concrete Swift types.
///
/// Input from JSON bodies, DB rows, and HTTP parameters arrives as `Any?`, where `value as? Int`
/// fails the moment a number arrives as `"42"`. Each method coerces the value and falls back to
/// `default` instead of throwing. ``uuid(_:default:optional:)`` is the exception, it throws.
///
/// ```swift
/// MCCast.int("42")            // 42
/// MCCast.int(raw, default: 0) // 0 when raw is nil/unconvertible
/// ```
public enum MCCast {}
