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
    
    public init( label: String = "com.miolabs.core.logger", file: String = #fileID, function: String = #function, line: UInt = #line )
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
        
        _logger.log(level: .debug, "Setting logger level: \(level)", file: file, function: function, line: line )
    }
    
    public func log( level: Logger.Level, _ message: Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line ) {
        _logger.log(level: level, message, file: file, function: function, line: line  )
    }
    
    public func trace   (_ message: Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .trace   , message, file: file, function: function, line: line ) }
    public func debug   (_ message: Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .debug   , message, file: file, function: function, line: line ) }
    public func info    (_ message: Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .info    , message, file: file, function: function, line: line ) }
    public func notice  (_ message: Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .notice  , message, file: file, function: function, line: line ) }
    public func warning (_ message: Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .warning , message, file: file, function: function, line: line ) }
    public func error   (_ message: Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .error   , message, file: file, function: function, line: line ) }
    public func critical(_ message: Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .critical, message, file: file, function: function, line: line ) }
}

extension MCLogger
{
    public func newModuleLogger( module: String, file: String = #fileID, function: String = #function, line: UInt = #line ) -> MCLogger {
        return MCLogger( label: self._logger.label + ".\(module)", file: file, function: function, line: line )
    }
}

