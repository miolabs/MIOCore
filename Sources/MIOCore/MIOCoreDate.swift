//
//  File.swift
//  
//
//  Created by David Trallero on 05/10/2020.
//

import Foundation

public func parse_date ( _ dateString: String ) -> Date? {
    
//    var date:Date?
//    autoreleasepool {
//
//        let df = dateFormaterInGMT0()
//
//        df.dateFormat = "yyyy-MM-dd"
//        if let ret = df.date( from: dateString ) { date = ret; return }
//
//        df.dateFormat = "yyyy-MM-dd HH:mm"
//        if let ret = df.date( from: dateString ) { date = ret; return }
//
//        df.dateFormat = "yyyy-MM-dd'T'HH:mm"
//        if let ret = df.date( from: dateString ) { date = ret; return }
//
//        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        if let ret = df.date( from: dateString ) { date = ret; return }
//
//        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" ;
//        if let ret = df.date( from: dateString ) { date = ret; return }
//
//        let rm_ms    = String( dateString.split( separator: "." )[ 0 ] )
//          , last_try = rm_ms.replacingOccurrences( of: "T", with: " " )
//
//        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        if let ret = df.date(from: last_try ) { date = ret; return }
//    }
//
//    return date
    
    return MIOCoreDate(fromString: dateString)
}


public func format_date ( _ date: Date ) -> String {
//    let df = MIOCoreDateGMT0Formatter()
//
//    df.dateFormat = "yyyy-MM-dd"
    
    return mcd_date_formatter().string( from: date )
}


public func format_time ( _ date: Date ) -> String {
//    let df = MIOCoreDateGMT0Formatter()
//    df.dateFormat = "HH:mm"
    
    return mcd_time_formatter().string( from: date )
}

public func dateFormaterInGMT0 ( ) -> DateFormatter {
    return MIOCoreDateGMT0Formatter()
}

var _MIOCoreDateFormatterInGMT0:DateFormatter?
public func MIOCoreDateGMT0Formatter() -> DateFormatter
{
    if _MIOCoreDateFormatterInGMT0 == nil {
        _MIOCoreDateFormatterInGMT0 = MIOCoreDateCreateGMT0Formatter()
    }
    
    return _MIOCoreDateFormatterInGMT0!
}

public func MIOCoreDateCreateGMT0Formatter() -> DateFormatter
{
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US_POSIX")
    df.timeZone = TimeZone(secondsFromGMT: 0)
    return df
}
 

public func MIOCoreDate(fromString dateString: String ) -> Date?
{
    var date:Date?
    MIOCoreAutoReleasePool {

        var sometime = tm()
        let formatString = "%Y-%m-%d %H:%M:%S"
        if strptime_l(dateString, formatString, &sometime, nil) != nil {
            date = Date(timeIntervalSince1970: TimeInterval(mktime(&sometime)))
            return
        }
        
        // Most probably case
        var df = mcd_date_time_formatter_s()
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
          , last_try = rm_ms.replacingOccurrences( of: "T", with: " " )

        df = mcd_date_time_formatter_s()
        if let ret = df.date(from: last_try ) { date = ret; return }
    }

    return date

}

public func MIOCoreDateTDateTimeFormatter() -> DateFormatter { return mcd_date_time_formatter_t_s() }

var _mcd_date_formatter:DateFormatter?
func mcd_date_formatter() -> DateFormatter
{
    if _mcd_date_formatter == nil {
        let df = MIOCoreDateCreateGMT0Formatter()
        df.dateFormat = "yyyy-MM-dd"
        _mcd_date_formatter = df
    }
    
    return _mcd_date_formatter!
}

var _mcd_time_formatter:DateFormatter?
func mcd_time_formatter() -> DateFormatter
{
    if _mcd_time_formatter == nil {
        let df = MIOCoreDateCreateGMT0Formatter()
        df.dateFormat = "HH:mm"
        _mcd_time_formatter = df
    }
    
    return _mcd_time_formatter!
}

var _mcd_date_time_formatter:DateFormatter?
func mcd_date_time_formatter() -> DateFormatter
{
    if _mcd_date_time_formatter == nil {
        let df = MIOCoreDateCreateGMT0Formatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        _mcd_date_time_formatter = df
    }
    
    return _mcd_date_time_formatter!
}

var _mcd_date_time_formatter_t:DateFormatter?
func mcd_date_time_formatter_t() -> DateFormatter
{
    if _mcd_date_time_formatter_t == nil {
        let df = MIOCoreDateCreateGMT0Formatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm"
        _mcd_date_time_formatter_t = df
    }
    
    return _mcd_date_time_formatter_t!
}

var _mcd_date_time_formatter_t_s:DateFormatter?
func mcd_date_time_formatter_t_s() -> DateFormatter
{
    if _mcd_date_time_formatter_t_s == nil {
        let df = MIOCoreDateCreateGMT0Formatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        _mcd_date_time_formatter_t_s = df
    }
    
    return _mcd_date_time_formatter_t_s!
}

var _mcd_date_time_formatter_z:DateFormatter?
func mcd_date_time_formatter_z() -> DateFormatter
{
    if _mcd_date_time_formatter_z == nil {
        let df = MIOCoreDateCreateGMT0Formatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        _mcd_date_time_formatter_z = df
    }
    
    return _mcd_date_time_formatter_z!
}

var _mcd_date_time_formatter_s:DateFormatter?
func mcd_date_time_formatter_s() -> DateFormatter
{
    if _mcd_date_time_formatter_s == nil {
        let df = MIOCoreDateCreateGMT0Formatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        _mcd_date_time_formatter_s = df
    }
    
    return _mcd_date_time_formatter_s!
}

