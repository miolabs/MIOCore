//
//  URLSession+Extension.swift
//  
//
//  Created by Javier Segura Perez on 17/10/21.
//

import Foundation

#if !os(WASI)

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


extension URLSession
{
    nonisolated public func synchronousDataTask(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
        nonisolated(unsafe) var data: Data?
        nonisolated(unsafe) var response: URLResponse?
        nonisolated(unsafe) var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
    
    public func synchronousUploadTask(with request: URLRequest, data:Data?) -> (Data?, URLResponse?, Error?) {
        nonisolated(unsafe) var resultData: Data?
        nonisolated(unsafe) var response: URLResponse?
        nonisolated(unsafe) var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.uploadTask(with: request, from: data) {
            resultData = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (resultData, response, error)
    }
    
    
}

#endif
