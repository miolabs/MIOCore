//
//  MIOCoreRPC.swift
//  MIOCore
//
//  Created by Javier Segura Perez on 9/9/24.
//

import Foundation
import MIOCoreContext
import MIOCore

public func RemoteProcedureCall( request: URLRequest ) async throws -> Data
{
    let sessionConfig = URLSessionConfiguration.ephemeral
    sessionConfig.timeoutIntervalForRequest = MIOCoreDoubleValue( time, 60 )!
    let session = URLSession( configuration: sessionConfig )

    let (data,response) = try await session.data(for: request )
    
    if (response as! HTTPURLResponse).statusCode >= 300 {
        throw MIOCoreError.general( "Bad response status from RPC" )
    }
                
    return data
}

extension MIOCoreContext
{
    public func remoteProcedureCall( request: URLRequest ) async throws -> Data {
        return try await RemoteProcedureCall( request: request )
    }
}
