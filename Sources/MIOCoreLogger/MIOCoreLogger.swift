//
//  MIOCoreLog.swift
//  MIOCore
//
//  Created by Javier Segura Perez on 17/8/24.
//

import Foundation
import Logging

@available(iOS 13.0.0, *)
actor MIOCoreLogger
{
    var _logger:Logger
    
    init()
    {
        _logger = Logger( label: "com.miolabs.core.logger" )
        
        var log_level = "info"
        
        if let value = getenv( "MC_LOGGER_LEVEL") {
            log_level = String(utf8String: value)!
        }
        
        var level:Logger.Level = .info
        switch log_level {
        case "trace": level = .trace
        case "debug": level = .debug
        case "info" : level = .info
        case "notice": level = .notice
        case "warning" : level = .warning
        case "error": level = .error
        case "critical": level = .critical
        default: break
        }
        
        _logger.logLevel = level
        _logger.log(level: .debug, "Setting log level: \(level)")
    }
    
    func log( level: Logger.Level, _ message: Logger.Message ) {
        _logger.log(level: level, message )
    }
        
}

@available(iOS 13.0.0, *)
let _logger = MIOCoreLogger()

public func Log( level:Logger.Level = .info, _ message:Logger.Message )
{
    if #available(iOS 13.0, *) {
        Task.detached {
            await _logger.log( level: level, message )
        }
    } else {
        // Fallback on earlier versions
    }
}
