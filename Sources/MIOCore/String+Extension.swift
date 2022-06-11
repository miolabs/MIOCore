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
    
    public func cString() -> UnsafeMutablePointer<UInt8> {
        var utf8 = Array(self.utf8)
        utf8.append(0)  // adds null character
        let count = utf8.count
        let result = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: count)
        _ = result.initialize(from: utf8)
        return result.baseAddress!
    }

}

extension String
{
    public func camelCaseToSnakeCase() -> String {

        var result = ""
        var prev_is_capital = false
        for i in 0..<count {
            let char = self[ index(startIndex, offsetBy: i) ]
            let next_char = i + 1 < count ? self[ index(startIndex, offsetBy: i + 1) ] : nil
            let next_is_non_capital = next_char?.isLowercase ?? false

            if char.isUppercase && result.count > 0 && (!prev_is_capital || next_is_non_capital) {
                result += "_"
            }
            prev_is_capital = char.isUppercase
            result += String(char.lowercased())
        }
        
        return result
    }

    
    public func snakeCaseToCamelCase ( ) -> String {
        return self.split(separator: "_").enumerated()
                   .map{ (index,part) in
                      index > 0 ? String( part ).capitalized : String( part ) }
                   .joined()
    }
}
