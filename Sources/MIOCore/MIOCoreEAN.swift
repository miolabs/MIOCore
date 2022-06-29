//
//  File.swift
//  
//
//  Created by David Trallero on 21/06/2021.
//

import Foundation


public enum EAN_TYPE: Int16 {
    case ean8  = 8
    case ean13 = 13
}

public func MIOCoreGenerateEAN ( type: EAN_TYPE , prefix: String, number: Int32 ) -> String {
    return generate_code_ean( type.rawValue, prefix, number )
}


func generate_code_ean ( _ length: Int16, _ prefix: String?, _ number: Int32 ) -> String {
    var code = prefix ?? ""
    let number_str = "\(number)"
    let padding = Int(length) - 1 - number_str.count - code.count
    
    code += String(repeating: "0", count: padding) + number_str
    
    return code + "\(calculate_ean_crc( code ))"
}



func calculate_ean_crc ( _ code: String ) -> UInt32 {
    var odd: UInt32 = 0, even: UInt32 = 0
    var i = 0
    
    for index in code.indices {
        let c = code[ index ]
        
        if (i % 2) != 0 {
            odd  += MIOCoreUInt32Value( String( c ) )!
        } else {
            even += MIOCoreUInt32Value( String( c ) )!
        }
        
        i += 1
    }
    
    let crc = ( ( ( odd * 3 ) +  even) % 10 )
    if crc == 0 { return UInt32( crc) }
    
    return UInt32(10) - UInt32( crc )
}
