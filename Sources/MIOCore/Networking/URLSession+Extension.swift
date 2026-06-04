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
    nonisolated public func synchronousDataTask(with request: URLRequest, timeout: TimeInterval = 10) -> (Data?, URLResponse?, Error?) {
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

        // Bound the wait to a hard wall-clock deadline. Without this,
        // a misbehaving server (no response, dropped connection, etc.)
        // causes the calling thread to block forever even when URLRequest
        // timeoutInterval is set — that field is unreliable on Linux's
        // FoundationNetworking. The semaphore wait is the only place we
        // control absolutely.
        let result = semaphore.wait(timeout: .now() + timeout)
        if result == .timedOut {
            // Cancel the underlying request so the URLSession isn't holding
            // the socket open after we've given up.
            dataTask.cancel()
            return (nil, nil, NSError(
                domain: "MIOCore.synchronousDataTask",
                code: NSURLErrorTimedOut,
                userInfo: [NSLocalizedDescriptionKey: "Synchronous request timed out after \(timeout)s"]
           ) )
       }

        return (data, response, error)
    }
    
    public func synchronousUploadTask(with request: URLRequest, data:Data?, timeout: TimeInterval = 10) -> (Data?, URLResponse?, Error?) {
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

        // Bound the wait to a hard wall-clock deadline. Without this,
        // a misbehaving server (no response, dropped connection, etc.)
        // causes the calling thread to block forever even when URLRequest
        // timeoutInterval is set — that field is unreliable on Linux's
        // FoundationNetworking. The semaphore wait is the only place we
        // control absolutely.
        let result = semaphore.wait(timeout: .now() + timeout)
        if result == .timedOut {
            // Cancel the underlying request so the URLSession isn't holding
            // the socket open after we've given up.
            dataTask.cancel()
            return (nil, nil, NSError(
                domain: "MIOCore.synchronousDataTask",
                code: NSURLErrorTimedOut,
                userInfo: [NSLocalizedDescriptionKey: "Synchronous request timed out after \(timeout)s"]
           ) )
       }

        return (resultData, response, error)
    }
    
    
}

#endif
