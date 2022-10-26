//
//  File.swift
//  
//
//  Created by David Trallero on 21/9/22.
//

import Foundation


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


public func MIOCoreJsonStringify ( withJSONObject obj: Any, options opt: JSONSerialization.WritingOptions = [] )  throws -> String? {
    do {
        return String( data: try MIOCoreJsonValue(withJSONObject: obj, options: opt ), encoding: .utf8 )
    }
    catch {
        print(error.localizedDescription)
        throw error
    }
}


public func MIOCoreSerializableJSON ( _ obj: Any ) -> Any {
    if let date = obj as? Date {
        let formatter = mcd_date_time_formatter_z( )
        
        return formatter.string( from: date )
    } else if let uuid = obj as? UUID {
        return uuid.uuidString.uppercased()
    } else if let dict = obj as? [String:Any] {
        var clean_dict = [:] as [String:Any]
        
        for key in dict.keys {
            clean_dict[ key ] = MIOCoreSerializableJSON( dict[ key ]! )
        }
        
        return clean_dict
    } else if let list = obj as? [Any] {
        return list.map{ MIOCoreSerializableJSON( $0 ) }
    }

    return obj
}
