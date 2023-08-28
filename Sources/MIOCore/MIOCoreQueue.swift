//
//  File.swift
//  
//
//  Created by Javier Segura Perez on 28/8/23.
//

import Foundation

var g_mc_queue: [ String: DispatchQueue ] = [:]

let main_core_queue = DispatchQueue(label: "com.miolabs.core.main" )

public func MIOCoreQueue ( label key: String, prefix:String = "com.miolabs.core" ) -> DispatchQueue {
    var queue:DispatchQueue? = nil
    
    main_core_queue.sync {
        if !g_mc_queue.keys.contains( key ) {
            g_mc_queue[ key ] = DispatchQueue(label: "\(prefix).\(key)" )
        }
        
        queue = g_mc_queue[ key ]
    }
    
    return queue!
}
