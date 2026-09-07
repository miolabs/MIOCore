//
//  URLSession+Extension.swift
//
//  Created by MIO Research Labs on 17/10/2021.
//

import Foundation

#if !os(WASI)

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    /// Runs a data task **synchronously**, blocking the caller until it finishes or times out.
    ///
    /// Waits on a semaphore bounded by a hard wall-clock `timeout`, necessary because
    /// `URLRequest.timeoutInterval` is unreliable on Linux's FoundationNetworking, which could
    /// otherwise block the thread forever. On timeout the underlying task is cancelled and an
    /// `NSURLErrorTimedOut` error is returned. Backs ``MCNetwork/dataRequestSync(_:)``.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - timeout: The maximum time to block, in seconds. Defaults to `10`.
    /// - Returns: A tuple of the response `Data`, `URLResponse`, and `Error` (any may be `nil`).
    nonisolated public func synchronousDataTask(with request: URLRequest, timeout: TimeInterval = 10) -> (Data?, URLResponse?, Error?) {
        nonisolated(unsafe) var data: Data?
        nonisolated(unsafe) var response: URLResponse?
        nonisolated(unsafe) var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let data_task = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        data_task.resume()

        // Bound the wait to a hard wall-clock deadline. Without this,
        // a misbehaving server (no response, dropped connection, etc.)
        // causes the calling thread to block forever even when URLRequest
        // timeoutInterval is set. That field is unreliable on Linux's
        // FoundationNetworking. The semaphore wait is the only place we
        // control absolutely.
        let result = semaphore.wait(timeout: .now() + timeout)
        if result == .timedOut {
            // Cancel the underlying request so the URLSession isn't holding
            // the socket open after we've given up.
            data_task.cancel()
            return (
                nil, nil,
                NSError(
                    domain: "MIOCore.synchronousDataTask",
                    code: NSURLErrorTimedOut,
                    userInfo: [NSLocalizedDescriptionKey: "Synchronous request timed out after \(timeout)s"]
                )
            )
        }

        return (data, response, error)
    }

    /// Runs an upload task **synchronously**, blocking the caller until it finishes or times out.
    ///
    /// The upload counterpart of ``synchronousDataTask(with:timeout:)``, same semaphore-bounded wait
    /// and timeout behavior, but sends `data` as the upload body.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - data: The body data to upload.
    ///   - timeout: The maximum time to block, in seconds. Defaults to `10`.
    /// - Returns: A tuple of the response `Data`, `URLResponse`, and `Error` (any may be `nil`).
    public func synchronousUploadTask(with request: URLRequest, data: Data?, timeout: TimeInterval = 10) -> (Data?, URLResponse?, Error?) {
        nonisolated(unsafe) var result_data: Data?
        nonisolated(unsafe) var response: URLResponse?
        nonisolated(unsafe) var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let data_task = self.uploadTask(with: request, from: data) {
            result_data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        data_task.resume()

        // Bound the wait to a hard wall-clock deadline. Without this,
        // a misbehaving server (no response, dropped connection, etc.)
        // causes the calling thread to block forever even when URLRequest
        // timeoutInterval is set. That field is unreliable on Linux's
        // FoundationNetworking. The semaphore wait is the only place we
        // control absolutely.
        let result = semaphore.wait(timeout: .now() + timeout)
        if result == .timedOut {
            // Cancel the underlying request so the URLSession isn't holding
            // the socket open after we've given up.
            data_task.cancel()
            return (
                nil, nil,
                NSError(
                    domain: "MIOCore.synchronousDataTask",
                    code: NSURLErrorTimedOut,
                    userInfo: [NSLocalizedDescriptionKey: "Synchronous request timed out after \(timeout)s"]
                )
            )
        }

        return (result_data, response, error)
    }

}

#endif
