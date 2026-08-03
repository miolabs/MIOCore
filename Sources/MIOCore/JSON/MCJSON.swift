//
//  MCJSON.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

/// Cross-platform JSON wrappers over `JSONSerialization`.
///
/// `JSONSerialization` rejects `Date` and `UUID`. ``serializable(_:)`` sanitizes the graph first
/// (`Date` -> ISO string, `UUID` -> uppercased string), and ``data(from:options:)`` /
/// ``string(from:options:)`` run that step before encoding, so values Foundation would otherwise
/// reject encode cleanly.
///
/// ```swift
/// let d = try MCJSON.data(from: ["ok": true, "n": 3])
/// let s = try MCJSON.string(from: payload)
/// ```
public enum MCJSON {

    /// Renders `Date` values as `yyyy-MM-dd'T'HH:mm:ss'Z'` strings during serialization.
    private static let json_formatter = MCDate.Formatters.z()

    /// Serializes an object graph to JSON `Data`, first making it safe to encode.
    ///
    /// Runs the input through ``serializable(_:)`` before handing it to `JSONSerialization`.
    ///
    /// - Parameters:
    ///   - obj: The object graph to serialize (dictionaries, arrays, and JSON scalars).
    ///   - opt: `JSONSerialization.WritingOptions` (e.g. `.prettyPrinted`). Defaults to `[]`.
    /// - Returns: The UTF-8 encoded JSON `Data`.
    /// - Throws: Any error thrown by `JSONSerialization`.
    public static func data(from obj: Any, options opt: JSONSerialization.WritingOptions = []) throws -> Data {
        let safe_obj = MCJSON.serializable(obj)
        do {
            return try JSONSerialization.data(withJSONObject: safe_obj, options: opt)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }

    /// Serializes an object graph to a JSON `String` (UTF-8), or `nil` if decoding the bytes fails.
    ///
    /// Convenience over ``data(from:options:)`` for logging and debugging.
    ///
    /// - Parameters:
    ///   - obj: The object graph to serialize.
    ///   - opt: `JSONSerialization.WritingOptions`. Defaults to `[]`.
    /// - Returns: The JSON string, or `nil` if the produced data is not valid UTF-8.
    /// - Throws: Any error thrown by `JSONSerialization`.
    public static func string(from obj: Any, options opt: JSONSerialization.WritingOptions = []) throws -> String? {
        do {
            return String(data: try MCJSON.data(from: obj, options: opt), encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }

    /// Recursively rewrites an object graph into JSON-serializable values.
    ///
    /// `JSONSerialization` rejects `Date` and `UUID`; this walks dictionaries and arrays and replaces
    /// them with canonical string forms, a `Date` via the `yyyy-MM-dd'T'HH:mm:ss'Z'` formatter, and a
    /// `UUID` as its uppercased string. Other values pass through unchanged.
    ///
    /// - Parameter obj: The object graph to sanitize.
    /// - Returns: An equivalent graph safe to pass to `JSONSerialization`.
    public static func serializable(_ obj: Any) -> Any {
        if let date = obj as? Date {
            return json_formatter.string(from: date)
        } else if let uuid = obj as? UUID {
            return uuid.uuidString.uppercased()
        } else if let dict = obj as? [String: Any] {
            var clean_dict = [:] as [String: Any]

            for (key, value) in dict {
                clean_dict[key] = MCJSON.serializable(value)
            }

            return clean_dict
        } else if let list = obj as? [Any] {
            return list.map { MCJSON.serializable($0) }
        }

        return obj
    }
}
