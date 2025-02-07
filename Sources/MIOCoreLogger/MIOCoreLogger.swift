//
//  MIOCoreLog.swift
//  MIOCore
//
//  Created by Javier Segura Perez on 17/8/24.
//

import Foundation
import Logging
import MIOCore

@available(iOS 13.0.0, *)
public final class MCLogger
{
    let _logger:Logger
    
    public init( label: String = "com.miolabs.core.logger" )
    {
        var logger = Logger( label: label )
        
        let log_level = MCEnvironmentVar("\(label).log-level")?.lowercased()
        
        let level:Logger.Level = switch log_level {
        case "trace": .trace
        case "debug": .debug
        case "info" : .info
        case "notice": .notice
        case "warning" : .warning
        case "error": .error
        case "critical": .critical
        default: .info
        }
        
        logger.logLevel = level
        _logger = logger
        
        _logger.log(level: .debug, "Setting LOG with level: \(level)")
    }
    
    public func log( level: Logger.Level, _ message: Logger.Message ) {
        _logger.log(level: level, message )
    }
    
    public func trace(_ message: Logger.Message) { log(level: .trace, message) }
    public func debug(_ message: Logger.Message) { log(level: .debug, message) }
    public func info(_ message: Logger.Message) { log(level: .info, message) }
    public func notice(_ message: Logger.Message) { log(level: .notice, message) }
    public func warning(_ message: Logger.Message) { log(level: .warning, message) }
    public func error(_ message: Logger.Message) { log(level: .error, message) }
    public func critical(_ message: Logger.Message) { log(level: .critical, message) }
}
