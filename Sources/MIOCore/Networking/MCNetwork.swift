//
//  MCNetwork.swift
//
//  Created by MIO Research Labs on 2026.
//

import Foundation

#if !os(WASI)

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Thin, cross-platform HTTP helpers over `URLSession`, for both async and blocking call sites.
///
/// Each request runs on a throwaway ephemeral session. The `...Sync` variants block the calling
/// thread, for server-side and script-style code that isn't async. Not available on WASI.
public enum MCNetwork {

    /// Performs an asynchronous data request on an ephemeral `URLSession`.
    ///
    /// Creates a throwaway ephemeral session per call (no shared cache/cookies) and invalidates it
    /// when done. Errors are logged and also passed to `completion`.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - completion: Called with the response `Data`, `URLResponse`, and/or `Error`.
    public static func dataRequest(_ request: URLRequest, completion: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) {
        //        let config = URLSessionConfiguration.default
        //        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        //        config.urlCache = nil
        //
        //        let session = URLSession(configuration: config)

        //        let sessionConfig = URLSessionConfiguration.default
        //        sessionConfig.timeoutIntervalForRequest = 30.0
        //        sessionConfig.timeoutIntervalForResource = 60.0
        //        let session = URLSession(configuration: sessionConfig)
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        defer { session.finishTasksAndInvalidate() }

        let task = session.dataTask(
            with: request,
            completionHandler: {
                data, response, error in

                if error != nil {
                    print(error!.localizedDescription)
                }

                completion(data, response, error)
            })

        task.resume()
    }

    /// Performs a **synchronous** (blocking) data request, returning the response bytes.
    ///
    /// The blocking counterpart of ``dataRequest(_:completion:)``, for server-side and script-style
    /// code paths that aren't async. Uses an ephemeral session with a 240s request timeout and blocks
    /// the calling thread until completion (via `URLSession.synchronousDataTask(with:timeout:)`).
    ///
    /// - Parameter request: The request to send.
    /// - Returns: The response `Data`, or `nil` if the body was empty.
    /// - Throws: The transport error if the request fails.
    public static func dataRequestSync(_ request: URLRequest) throws -> Data? {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 240
        //    config.requestCachePolicy = .reloadIgnoringLocalCacheData
        //    config.urlCache = nil

        let session = URLSession.init(configuration: config)
        defer { session.finishTasksAndInvalidate() }

        let (data, _, error) = session.synchronousDataTask(with: request)

        if error != nil {
            print("ERROR MCNetwork.dataRequestSync: \(error!.localizedDescription)")
            print("ERROR Request: \(request)")
            print("ERROR Body: \(request.httpBody ?? Data())")
            throw error!
        }

        // TODO: Check response code

        return data
    }

    /// Performs an asynchronous JSON request, decoding the response into a dictionary.
    ///
    /// Sets `Content-Type: application/json`, sends via ``dataRequest(_:completion:)``, and parses the
    /// response body. The completion is always dispatched on the main queue.
    ///
    /// - Parameters:
    ///   - request: The request to send.
    ///   - completion: Called with the decoded `[String: Any]` (or `nil`) and any error.
    public static func jsonRequest(_ request: URLRequest, completion: @Sendable @escaping ([String: Any]?, Error?) -> Void) {
        var r = request
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")

        dataRequest(r) {
            data, response, error in

            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                DispatchQueue.main.async {
                    completion(json, nil)
                }
                return
            } catch let error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    /// Performs a **synchronous** JSON request, returning the parsed JSON object.
    ///
    /// The blocking counterpart of ``jsonRequest(_:completion:)``. Defaults the `Content-Type` to
    /// `application/json` when unset, then parses the response with `JSONSerialization`.
    ///
    /// - Parameter request: The request to send.
    /// - Returns: The parsed JSON object (typically a dictionary or array), or `nil` if the body was empty.
    /// - Throws: The transport error, or a `JSONSerialization` error if the body is not valid JSON.
    public static func jsonRequestSync(_ request: URLRequest) throws -> Any? {
        var r = request

        if r.value(forHTTPHeaderField: "Content-Type") == nil {
            r.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let data = try dataRequestSync(r)
        if data == nil { return nil }

        let json = try JSONSerialization.jsonObject(with: data!, options: [])
        return json
    }

    /// Builds and synchronously executes a JSON request from a dictionary body, the one-call convenience.
    ///
    /// Serializes `body` with ``MCJSON/data(from:options:)`` and forwards to the `Data`-body overload.
    ///
    /// ```swift
    /// let json = try MCNetwork.jsonRequestExecute(method: "POST",
    ///                                         urlString: "https://api.example.com/charge",
    ///                                         body: ["amount": 25],
    ///                                         headers: ["Authorization": "Bearer ..."])
    /// ```
    ///
    /// - Parameters:
    ///   - method: The HTTP method. Defaults to `"GET"`.
    ///   - urlString: The absolute URL string.
    ///   - body: The request body as a JSON-serializable dictionary.
    ///   - headers: Additional header fields.
    /// - Returns: The parsed JSON response, or `nil`.
    /// - Throws: A serialization or transport error.
    public static func jsonRequestExecute(method: String = "GET", urlString: String, body: [String: Any]? = nil, headers: [String: String]? = nil) throws -> Any? {

        let data = body != nil ? try MCJSON.data(from: body!, options: []) : nil
        return try jsonRequestExecute(method: method, urlString: urlString, body: data, headers: headers)
    }

    /// Builds and synchronously executes a JSON request from a raw `Data` body.
    ///
    /// The `Data`-body overload of ``jsonRequestExecute(method:urlString:body:headers:)-(_,_,[String:Any]?,_)``;
    /// use it when you already have encoded bytes rather than a dictionary.
    ///
    /// - Parameters:
    ///   - method: The HTTP method. Defaults to `"GET"`.
    ///   - urlString: The absolute URL string.
    ///   - body: The pre-encoded request body.
    ///   - headers: Additional header fields.
    /// - Returns: The parsed JSON response cast to `[String: Any]`, or `nil`.
    /// - Throws: A transport or parsing error.
    public static func jsonRequestExecute(method: String = "GET", urlString: String, body: Data? = nil, headers: [String: String]? = nil) throws -> Any? {
        let data = body
        var r = URLRequest(method: method, urlString: urlString, body: data)
        if headers != nil {
            for (key, value) in headers! { r.setValue(value, forHTTPHeaderField: key) }
        }
        return try jsonRequestSync(r) as? [String: Any]
    }
}

//public func MIOCoreURLFileRequest(_ request:URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
//
//    var r = request
//    r.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//
//    MIOCoreURLDataRequest(r, completion: completion)
//}

#endif
