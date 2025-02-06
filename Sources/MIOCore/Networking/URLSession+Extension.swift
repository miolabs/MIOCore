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
        var data: Data?
        var response: URLResponse?
        var error: Error?

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
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.uploadTask(with: request, from: data) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
    
    
}

#endif
