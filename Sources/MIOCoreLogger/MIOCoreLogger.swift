//
//  MIOCoreLog.swift
//  MIOCore
//
//  Created by Javier Segura Perez on 17/8/24.
//

import Foundation
import Logging
import MIOCore

extension String
{
    func camelCase() -> String {
        return unicodeScalars.dropFirst().reduce(String(prefix(1))) {
            return CharacterSet.uppercaseLetters.contains($1)
                    ? $0 + "-" + String($1)
                    : $0 + String($1)
        }
    }
}

let _log_queue = DispatchQueue(label: "com.miolabs.log-queue")

@available(iOS 13.0.0, *)
public final class Log
{
    static var loggers: [String:MCLogger] = [:]
    
    static func log( level: Logger.Level, _ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line ) {
        
        func remove_extension( _ path:String ) -> String {
            if let dotIndex = path.utf8.lastIndex(of: UInt8(ascii: ".")) {
                return String( path[ ..<dotIndex ] )
            }
            
            return path
        }
                        
        let path = remove_extension( file ).replacingOccurrences(of: "/", with: "." )
        
        var logger:MCLogger? = nil
        if logger == nil {
            _log_queue.sync {
                logger = loggers[ path ]
                if logger != nil { return }
                logger = MCLogger( label: path, file: file, function: function, line: line )
                loggers[ path ] = logger
            }
        }

        logger!.log( level: level, message(), file: file, function: function, line: line )
    }
    
    static public func newCustomLogger(_ label:String, file: String = #fileID, function: String = #function, line: UInt = #line) -> Logger {
        var logger:MCLogger? = nil
        _log_queue.sync {
            logger = loggers[ label ]
            if logger != nil { return }
            logger = MCLogger( label: label, file: file, function: function, line: line )
            loggers[ label ] = logger
        }
        return logger!._logger
    }
    
    static public func trace   (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .trace  , message(), file: file, function: function, line: line ) }
    static public func debug   (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .debug   , message(), file: file, function: function, line: line ) }
    static public func info    (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .info    , message(), file: file, function: function, line: line ) }
    static public func notice  (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .notice  , message(), file: file, function: function, line: line ) }
    static public func warning (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .warning , message(), file: file, function: function, line: line ) }
    static public func error   (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .error   , message(), file: file, function: function, line: line ) }
    static public func critical(_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .critical, message(), file: file, function: function, line: line ) }
}

@available(iOS 13.0.0, *)
final class MCLogger
{
    let _logger:Logger
    
    public init( label:String, file: String = #fileID, function: String = #function, line: UInt = #line )
    {
        var log_level:String? = nil
        var components = label.split(separator: ".")
        while components.isEmpty == false {
            let module = ( components.joined( separator: "." ) + ".LogLevel" ).lowercased( )
            log_level = MCEnvironmentVar( module )?.lowercased()
            if log_level != nil { break }
            components = components.dropLast()
        }
                
        let level:Logger.Level = switch log_level {
        case "trace"   : .trace
        case "debug"   : .debug
        case "info"    : .info
        case "notice"  : .notice
        case "warning" : .warning
        case "error"   : .error
        case "critical": .critical
        default: .info
        }
                
        var l = Logger( label: label )
        l.logLevel = level
        
        _logger = l
        _logger.log(level: .debug, "Setting logger level: \(level)", file: file, function: function, line: line )
    }
    
    public func log( level: Logger.Level, _ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line ) {
        _logger.log( level: level, message(), file: file, function: function, line: line )
    }
    
    public func trace   (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .trace  , message(), file: file, function: function, line: line ) }
    public func debug   (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .debug   , message(), file: file, function: function, line: line ) }
    public func info    (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .info    , message(), file: file, function: function, line: line ) }
    public func notice  (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .notice  , message(), file: file, function: function, line: line ) }
    public func warning (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .warning , message(), file: file, function: function, line: line ) }
    public func error   (_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .error   , message(), file: file, function: function, line: line ) }
    public func critical(_ message: @autoclosure () -> Logger.Message, file: String = #fileID, function: String = #function, line: UInt = #line) { log( level: .critical, message(), file: file, function: function, line: line ) }
}

