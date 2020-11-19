//
//  File.swift
//  
//
//  Created by David Trallero on 05/10/2020.
//

import Foundation

public func parse_date ( _ dateString: String ) -> Date? {
    let df = dateFormaterInGMT0()

    df.dateFormat = "yyyy-MM-dd"
    if let ret = df.date( from: dateString ) { return ret }

    df.dateFormat = "yyyy-MM-dd HH:mm"
    if let ret = df.date( from: dateString ) { return ret }

    df.dateFormat = "yyyy-MM-dd'T'HH:mm"
    if let ret = df.date( from: dateString ) { return ret }

    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    if let ret = df.date( from: dateString ) { return ret }

    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" ;
    if let date = df.date( from: dateString ) { return date }

    let rm_ms    = String( dateString.split( separator: "." )[ 0 ] )
      , last_try = rm_ms.replacingOccurrences( of: "T", with: " " )

    df.dateFormat = "YYYY-MM-dd HH:mm:ss"
    if let date = df.date(from: last_try ) { return date }
    
    return nil
}


public func format_date ( _ date: Date ) -> String {
    let df = dateFormaterInGMT0()

    df.dateFormat = "yyyy-MM-dd"
    
    return df.string( from: date )
}


public func format_time ( _ date: Date ) -> String {
    let df = dateFormaterInGMT0()
    df.dateFormat = "HH:mm"
    
    return df.string( from: date )
}

public func dateFormaterInGMT0 ( ) -> DateFormatter {
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US_POSIX")
    df.timeZone = TimeZone(secondsFromGMT: 0)
    
    return df
}
