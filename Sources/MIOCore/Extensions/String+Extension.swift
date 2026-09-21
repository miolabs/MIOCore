//
//  String+Extension.swift
//
//  Created by MIO Research Labs on 31/03/2021.
//

import Foundation

extension String {

    /// Substitutes `{{key}}` placeholders in the string with values from a parameter dictionary.
    ///
    /// Each key is matched as `{{key}}` (double braces). Only `String` values are substituted; a
    /// `nil` dictionary returns the receiver unchanged.
    ///
    /// ```swift
    /// "Hi {{name}}".replacing(withParams: ["name": "Ana"])   // "Hi Ana"
    /// ```
    ///
    /// - Parameter params: The placeholder → replacement map, or `nil` to leave the string as is.
    /// - Returns: The string with all matched placeholders replaced.
    public func replacing(withParams params: [String: Any]?) -> String {
        if params == nil { return self }

        var result = self

        for (key, value) in params! {
            let param = "{{" + key + "}}"
            guard let v = value as? String else {
                continue
            }
            NSLog("-> param: \(key), value: \(value)")
            result = result.replacingOccurrences(of: param, with: v)
        }

        return result
    }

    /// Returns a heap-allocated, null-terminated UTF-8 C string for interop with C APIs.
    ///
    /// Used by the DB drivers that bridge to C libraries (e.g. libpq).
    ///
    /// - Important: The caller owns the returned buffer and is responsible for freeing it; it is not
    ///   released automatically.
    /// - Returns: A pointer to a newly allocated, null-terminated UTF-8 byte buffer.
    public func cString() -> UnsafeMutablePointer<UInt8> {
        var utf8 = Array(self.utf8)
        utf8.append(0)  // adds null character
        let count = utf8.count
        let result = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: count)
        _ = result.initialize(from: utf8)
        return result.baseAddress!
    }

    /// Converts a `camelCase` identifier to `snake_case`.
    ///
    /// Used to map Swift property names to database column / JSON key conventions.
    ///
    /// ```swift
    /// "helloWorld".camelCaseToSnakeCase()   // "hello_world"
    /// ```
    ///
    /// - Returns: The snake-cased string.
    public func camelCaseToSnakeCase() -> String {
        var result = ""
        var prev_is_capital = false
        for i in 0..<count {
            let char = self[index(startIndex, offsetBy: i)]
            let next_char = i + 1 < count ? self[index(startIndex, offsetBy: i + 1)] : nil
            let next_is_non_capital = next_char?.isLowercase ?? false

            if char.isUppercase && result.count > 0 && (!prev_is_capital || next_is_non_capital) {
                result += "_"
            }
            prev_is_capital = char.isUppercase
            result += String(char.lowercased())
        }

        return result
    }

    /// Converts a `snake_case` identifier to `camelCase`.
    ///
    /// The inverse of ``camelCaseToSnakeCase()``.
    ///
    /// ```swift
    /// "hello_world".snakeCaseToCamelCase()   // "helloWorld"
    /// ```
    ///
    /// - Returns: The camel-cased string.
    public func snakeCaseToCamelCase() -> String {
        self.split(separator: "_").enumerated()
            .map { (index, part) in
                index > 0 ? String(part).capitalized : String(part)
            }
            .joined()
    }

    /// Returns the character at an integer offset as a single-character `String`.
    ///
    /// A convenience over `String.Index` arithmetic.
    ///
    /// - Parameter idx: The zero-based character offset. Must be within bounds.
    /// - Returns: The character at `idx` as a `String`.
    public subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }

    /// Returns the substring for a half-open integer range (`lower..<upper`).
    ///
    /// - Parameter bounds: The half-open range of character offsets. Must be within bounds.
    /// - Returns: The substring as a `String`.
    public subscript(bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    /// Returns the substring for a closed integer range (`lower...upper`).
    ///
    /// - Parameter bounds: The closed range of character offsets. Must be within bounds.
    /// - Returns: The substring as a `String`.
    public subscript(bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

}
