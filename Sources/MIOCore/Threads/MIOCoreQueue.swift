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

let main_core_queue = DispatchQueue(label: "com.miolabs.core.main", attributes: .concurrent )

public func MIOCoreQueue ( label key: String, prefix:String = "com.miolabs.core" ) -> DispatchQueue 
{
    // Makes faster read if the queue exists
    var queue:DispatchQueue? = main_core_queue.sync( ) {
        return g_mc_queue[ key ]
    }
    
    if let q = queue { return q }
    
    main_core_queue.sync( flags: .barrier ) {
        g_mc_queue[ key ] = DispatchQueue(label: "\(prefix).\(key)" )
    }
        
    queue = g_mc_queue[ key ]
    return queue!
}

public func MIOCoreQueueStatus ( label key: String, prefix:String = "com.miolabs.core" ) -> Bool
{
    let status = main_core_queue.sync( ) {
        return g_mc_queue_status[ "\(prefix).\(key)" ] ?? false
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
