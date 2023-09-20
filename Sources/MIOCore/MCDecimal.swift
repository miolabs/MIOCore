//
//  MCDecimal.swift
//  
//
//  Created by Javier Segura Perez on 19/9/23.
//

import Foundation

@available(*, deprecated, renamed: "MCDecimal", message: "Deprecated: change by MCDecimal instead")
public func MIOCoreDecimalValue ( _ value: Any?, _ def_value: Decimal? = nil ) -> Decimal? { return MCDecimalValue(value, def_value) }

public func MCDecimalValue ( _ value: Any?, _ def_value: Decimal? = nil ) -> Decimal?
{
    if value == nil { return def_value }
    
    if let asString  = value! as? String     { return Decimal( string: asString ) ?? def_value }
    if let asDecimal = value! as? Decimal    { return asDecimal }
    if let asDouble  = value! as? Double     { return Decimal( floatLiteral: asDouble ) }
    if let asInt     = MIOCoreIntValue( value ) { return Decimal( integerLiteral: asInt ) }

    return def_value
}

extension Decimal
{
    public func rounding( ) -> Decimal { return roundingBy( scale: 2, roundingMode: .bankers ) }
    
    public func roundingBy( scale:Int, roundingMode: NSDecimalNumber.RoundingMode ) -> Decimal
    {
        var d = self
        var rounded = Decimal()
        NSDecimalRound( &rounded, &d, scale, roundingMode )
        return rounded
    }
}

extension NSDecimalNumber
{
    public func rounding( ) -> Decimal { return roundingBy( scale: 2, roundingMode: .bankers ) }
    
    public func roundingBy( scale:Int, roundingMode: NSDecimalNumber.RoundingMode ) -> Decimal
    {
        return (self as Decimal).roundingBy(scale: scale, roundingMode: roundingMode)
    }
}
