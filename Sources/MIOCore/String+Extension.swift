//
//  File.swift
//  
//
//  Created by David Trallero on 31/03/2021.
//

import Foundation


extension String {
    
    public func replacing (_ replace_string:String, with new_string:String) -> String {
        var ret: String = ""
        var cmp: Bool = false
        var replace_index: String.Index = replace_string.startIndex
        var start_index: String.Index = replace_string.startIndex
        var i: String.Index = self.startIndex
        
        while i != self.endIndex {
            let ch = self[ i ]
            let rpl_ch = replace_string[ replace_index ]
            
            if cmp == false && ch == rpl_ch {
                cmp = true
                replace_index = replace_string.startIndex
                start_index = self.startIndex
            }
            
            if cmp == true {
                if self[ i ] == replace_string[ replace_index ] {
                    replace_index = replace_string.index( after: replace_index )
                    
                    if replace_index == replace_string.endIndex {
                        ret.append( new_string )
                        cmp = false
                        replace_index = replace_string.startIndex
                    }
                } else {
                    ret.append( contentsOf: replace_string[ start_index ..< i ] )
                    cmp = false
                }
            } else {
              ret.append( ch )
            }
            
            i = self.index(after: i)
        }
        
        return ret
    }
    
    public func replacing(withParams params:[String:Any]?) -> String {
        
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

}
