//
//  MIOCoreDate.swift
//
//
//  Created by David Trallero on 05/10/2020.
//

import Foundation

// Thread-local DateFormatter cache to ensure thread safety
private func threadFormatter(_ key: String, factory: () -> Formatter) -> Formatter {
    let dict = Thread.current.threadDictionary
    if let df = dict[key] as? Formatter { return df }
    let df = factory()
    dict[key] = df
    return df
}

public func parse_date ( _ dateString: String ) throws -> Date {
    let ret = MIOCoreDate(fromString: dateString )
            
    if ret == nil {
        throw MIOCoreError.general( "Could not parse date >>\(dateString)<<" )
    }
    
    #if DEBUG
    return ret!
//    return ret!.addingTimeInterval( 60 * 60 * 2)
    #else
    return ret!
    #endif
    
}


public func parse_date_or_nil ( _ dateString: String? ) -> Date? {
    return dateString == nil ? nil : MCDateGMT0Parser( dateString! )
}


public func format_date ( _ date: Date ) -> String {
    return mcd_date_formatter().string( from: date )
}


public func format_time ( _ date: Date ) -> String {
//    let df = MIOCoreDateGMT0Formatter()
//    df.dateFormat = "HH:mm"
    
    return mcd_time_formatter().string( from: date )
}

public func format_date_time ( _ date: Date ) -> String {
    return mcd_date_time_formatter().string( from: date )
}


public func format_date_time_t ( _ date: Date ) -> String {
    return mcd_date_time_formatter_t().string( from: date )
}


public func parse_time ( _ time: String ) throws -> Date {
    let ret = mcd_time_formatter().date( from: time )
    
    if ret == nil {
        throw MIOCoreError.general( "Time >>\(time)<< could not be parsed" )
    }
    
    return ret!
}

public func parse_time_or_nil ( _ time: String ) -> Date? {
    return mcd_time_formatter().date( from: time )
}


public func dateFormaterInGMT0 ( ) -> DateFormatter {
    return MIOCoreDateGMT0Formatter()
}

public func MIOCoreDateGMT0Formatter() -> DateFormatter {
    return threadFormatter("MIOCoreDateGMT0Formatter") { MIOCoreDateCreateGMT0Formatter() } as! DateFormatter
}

public func MIOCoreISO8601Formatter() -> ISO8601DateFormatter {
    return threadFormatter("MIOCoreISO8601Formatter") { mcd_date_time_formatter_iso() } as! ISO8601DateFormatter
}

public func MIOCoreDateCreateGMT0Formatter() -> DateFormatter
{
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US_POSIX")
    df.timeZone = TimeZone(secondsFromGMT: 0)
    return df
}

public func MCDateGMT0Parser( _ string: String ) -> Date?
{
    let formatter = ISO8601DateFormatter()
    var date_str = string
        
    
    var options: ISO8601DateFormatter.Options = [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        
    if string.count == 10 {
        formatter.formatOptions = options
        return formatter.date(from: date_str )
    }
    
    if !string.contains( "T" ) { options.insert( .withSpaceBetweenDateAndTime ) }
    if string.count == 16 { date_str += ":00" }

    options.insert( [ .withTime, .withColonSeparatorInTime ] )
    formatter.formatOptions = options
    return formatter.date(from: date_str )
}
 
public func MCDateGMT0Format( _ date: Date ) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [ .withYear,  .withMonth, .withDay, .withDashSeparatorInDate]
    return formatter.string(from:  date )
}

public func MCTimeGMT0Format( _ date: Date ) -> String {
    let df = DateFormatter()
//    df.locale = Locale(identifier: "en_US_POSIX")
    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.dateFormat = "HH:mm"
    return df.string( from: date )

}


public func MIOCoreDate(fromString dateString: String ) -> Date?
{
    var date:Date?
    MIOCoreAutoReleasePool {

        var df:DateFormatter
                
        // Most probably case
        df = mcd_date_time_formatter_s()
        if let ret = df.date(from: dateString ) { date = ret; return }
        
        // Check other cases
        df = mcd_date_formatter()
        if let ret = df.date( from: dateString ) { date = ret; return }
        
        df = mcd_date_time_formatter()
        if let ret = df.date( from: dateString ) { date = ret; return }

        df = mcd_date_time_formatter_t()
        if let ret = df.date( from: dateString ) { date = ret; return }

        df = mcd_date_time_formatter_t_s()
        if let ret = df.date( from: dateString ) { date = ret; return }

        df = mcd_date_time_formatter_z()
        if let ret = df.date( from: dateString ) { date = ret; return }

        let rm_ms    = String( dateString.split( separator: "." )[ 0 ] )
        var last_try = rm_ms.replacingOccurrences( of: "T", with: " " )
        
        if last_try.count > 19 {
            last_try = String( last_try[..<last_try.index(last_try.startIndex, offsetBy: 19)] )
            
        }

        df = mcd_date_time_formatter_s()
        if let ret = df.date(from: last_try ) { date = ret; return }
        
        //df = mcd_date_time_formatter_s()
        //if let ret = df.date(from: last_try ) { date = ret; return }
        
        // Check for a timeshift
        let r = last_try.index(last_try.startIndex, offsetBy: 11)..<last_try.index(last_try.startIndex, offsetBy: 13)
        let hh = String( last_try[ r ] )
        var h = MIOCoreIntValue( hh, 0 )!
        h -= 1
        last_try.replaceSubrange( r, with: String(format: "%02i", h ) )
        
        if let ret = df.date(from: last_try ) { date = ret; return }
    }

    return date

}

public func MIOCoreDateTDateTimeFormatter() -> DateFormatter { return mcd_date_time_formatter_t_s() }

func mcd_date_formatter() -> DateFormatter {
    return threadFormatter("mcd_date_formatter") {
        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = "yyyy-MM-dd"
        return df
    } as! DateFormatter
}

func mcd_time_formatter() -> DateFormatter {
    return threadFormatter("mcd_time_formatter") {
        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = "HH:mm"
        return df
    } as! DateFormatter
}

func mcd_date_time_formatter() -> DateFormatter {
    return threadFormatter("mcd_date_time_formatter") {
        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = "yyyy-MM-dd HH:mm"
        return df
    } as! DateFormatter
}

func mcd_date_time_formatter_t() -> DateFormatter {
    return threadFormatter("mcd_date_time_formatter_t") {
        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return df
    } as! DateFormatter
}

func mcd_date_time_formatter_t_s() -> DateFormatter {
    return threadFormatter("mcd_date_time_formatter_t_s") {
        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df
    } as! DateFormatter
}

func mcd_date_time_formatter_iso() -> ISO8601DateFormatter {
    return threadFormatter("mcd_date_time_iso") {
        let df = ISO8601DateFormatter()
//        df.locale = Locale.current
//        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        df.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return df
    } as! ISO8601DateFormatter
}


func mcd_date_time_formatter_z() -> DateFormatter {
    return threadFormatter("mcd_date_time_formatter_z") {
        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return df
    } as! DateFormatter
}

func mcd_date_time_formatter_s() -> DateFormatter {
    return threadFormatter("mcd_date_time_formatter_s") {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    } as! DateFormatter
}
