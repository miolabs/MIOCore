//
//  File.swift
//  
//
//  Created by Javier Segura Perez on 28/8/23.
//

import Foundation

#if !os(WASI)

var g_mc_queue: [ String: DispatchQueue ] = [:]
var g_mc_queue_status: [ String: Bool ] = [:]

let main_core_queue = DispatchQueue(label: "com.miolabs.core.main" )

public func MIOCoreQueue ( label key: String, prefix:String = "com.miolabs.core" ) -> DispatchQueue 
{
    var queue:DispatchQueue? = nil
    
    main_core_queue.sync( flags: .barrier ) {
        if !g_mc_queue.keys.contains( key ) {
            g_mc_queue[ key ] = DispatchQueue(label: "\(prefix).\(key)" )
        }
        
        queue = g_mc_queue[ key ]
    }
    
    return queue!
}

public func MIOCoreQueueStatus ( label key: String, prefix:String = "com.miolabs.core" ) -> Bool
{
    var status = false
    
    main_core_queue.sync( flags: .barrier ) {
        status = g_mc_queue_status[ "\(prefix).\(key)" ] ?? false
    }
    
    return status
}

public func MIOCoreQueueSetStatus ( value:Bool, label key: String, prefix:String = "com.miolabs.core" )
{
    main_core_queue.sync( flags: .barrier ) {
        g_mc_queue_status[ "\(prefix).\(key)" ] = value
    }
}

#endif
