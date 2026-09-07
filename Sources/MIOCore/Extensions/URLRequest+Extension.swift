//
//  URLRequest+Extension.swift
//
//  Created by MIO Research Labs on 17/10/2021.
//

import Foundation

#if !os(WASI)

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {
    /// Builds a `URLRequest` from a URL string, method, optional body, and headers.
    ///
    /// A convenience initializer that avoids the usual multi-step `URLRequest` setup.
    ///
    /// - Parameters:
    ///   - method: The HTTP method. Defaults to `"GET"`.
    ///   - urlString: The absolute URL string. Force-unwrapped, must be a valid URL.
    ///   - body: The HTTP body, if any.
    ///   - headers: Additional header fields to set.
    ///   - mimeType: Convenience for setting the `Content-Type` header.
    public init(method: String = "GET", urlString: String, body: Data? = nil, headers: [String: String]? = nil, mimeType: String? = nil) {
        self.init(url: URL(string: urlString)!)
        httpMethod = method
        httpBody = body
        if mimeType != nil { setValue(mimeType!, forHTTPHeaderField: "Content-Type") }
        if headers != nil {
            for (key, value) in headers! { setValue(value, forHTTPHeaderField: key) }
        }
    }
}

#endif
