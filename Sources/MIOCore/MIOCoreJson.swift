//
//  File.swift
//  
//
//  Created by David Trallero on 21/9/22.
//

import Foundation


/// Serializes an object graph to JSON `Data`, first making it safe to encode.
///
/// Runs the input through ``MIOCoreSerializableJSON(_:)`` (converting `Date`/`UUID` and cleaning
/// nested containers) before handing it to `JSONSerialization`, so values Foundation would otherwise
/// reject encode cleanly.
///
/// ```swift
/// let data = try MIOCoreJsonValue(withJSONObject: ["ok": true, "n": 3])
/// ```
///
/// - Parameters:
///   - obj: The object graph to serialize (dictionaries, arrays, and JSON scalars).
///   - opt: `JSONSerialization.WritingOptions` (e.g. `.prettyPrinted`). Defaults to `[]`.
/// - Returns: The UTF-8 encoded JSON `Data`.
/// - Throws: Any error thrown by `JSONSerialization`.
public func MIOCoreJsonValue ( withJSONObject obj: Any, options opt: JSONSerialization.WritingOptions = [] )  throws -> Data {
    let safe_obj = MIOCoreSerializableJSON( obj )
    do {
        return try JSONSerialization.data( withJSONObject: safe_obj, options: opt )
    }
    catch {
        print(error.localizedDescription)
        throw error
    }
}


/// Serializes an object graph to a JSON `String` (UTF-8), or `nil` if decoding the bytes fails.
///
/// Convenience over ``MIOCoreJsonValue(withJSONObject:options:)`` for logging and debugging.
///
/// ```swift
/// let text = try MIOCoreJsonStringify(withJSONObject: payload)
/// ```
///
/// - Parameters:
///   - obj: The object graph to serialize.
///   - opt: `JSONSerialization.WritingOptions`. Defaults to `[]`.
/// - Returns: The JSON string, or `nil` if the produced data is not valid UTF-8.
/// - Throws: Any error thrown by `JSONSerialization`.
public func MIOCoreJsonStringify ( withJSONObject obj: Any, options opt: JSONSerialization.WritingOptions = [] )  throws -> String? {
    do {
        return String( data: try MIOCoreJsonValue(withJSONObject: obj, options: opt ), encoding: .utf8 )
    }
    catch {
        print(error.localizedDescription)
        throw error
    }
}

let json_formatter = mcd_date_time_formatter_z( )

/// Recursively rewrites an object graph into JSON-serializable values.
///
/// `JSONSerialization` rejects `Date` and `UUID`; this walks dictionaries and arrays and replaces
/// them with canonical string forms, a `Date` via the `yyyy-MM-dd'T'HH:mm:ss'Z'`
/// formatter, and a `UUID` as its uppercased string. Other values pass through unchanged.
///
/// - Parameter obj: The object graph to sanitize.
/// - Returns: An equivalent graph safe to pass to `JSONSerialization`.
public func MIOCoreSerializableJSON ( _ obj: Any ) -> Any {
    if let date = obj as? Date {
        return json_formatter.string( from: date )
    } else if let uuid = obj as? UUID {
        return uuid.uuidString.uppercased()
    } else if let dict = obj as? [String:Any] {
        var clean_dict = [:] as [String:Any]
        
        for (key,value) in dict {
            clean_dict[ key ] = MIOCoreSerializableJSON( value )
        }
        
        return clean_dict
    } else if let list = obj as? [Any] {
        return list.map{ MIOCoreSerializableJSON( $0 ) }
    }

    return obj
}
