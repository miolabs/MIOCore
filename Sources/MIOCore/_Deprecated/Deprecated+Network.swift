//
//  Deprecated+Network.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous HTTP-request signatures. Use MCNetwork instead. Kept as forwards so downstream keeps building.
//

import Foundation

#if !os(WASI)

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@available(*, deprecated, renamed: "MCNetwork.dataRequest(_:completion:)")
public func MIOCoreURLDataRequest(_ request: URLRequest, completion: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) {
    MCNetwork.dataRequest(request, completion: completion)
}

@available(*, deprecated, renamed: "MCNetwork.dataRequestSync(_:)")
public func MIOCoreURLDataRequest_sync(_ request: URLRequest) throws -> Data? {
    try MCNetwork.dataRequestSync(request)
}

@available(*, deprecated, renamed: "MCNetwork.jsonRequest(_:completion:)")
public func MIOCoreURLJSONRequest(_ request: URLRequest, completion: @Sendable @escaping ([String: Any]?, Error?) -> Void) {
    MCNetwork.jsonRequest(request, completion: completion)
}

@available(*, deprecated, renamed: "MCNetwork.jsonRequestSync(_:)")
public func MIOCoreURLJSONRequest_sync(_ request: URLRequest) throws -> Any? {
    try MCNetwork.jsonRequestSync(request)
}

@available(*, deprecated, renamed: "MCNetwork.jsonRequestExecute(method:urlString:body:headers:)")
public func MIOCoreURLJSONRequestExecute(method: String = "GET", urlString: String, body: [String: Any]? = nil, headers: [String: String]? = nil) throws -> Any? {
    try MCNetwork.jsonRequestExecute(method: method, urlString: urlString, body: body, headers: headers)
}

@available(*, deprecated, renamed: "MCNetwork.jsonRequestExecute(method:urlString:body:headers:)")
public func MIOCoreURLJSONRequestExecute(method: String = "GET", urlString: String, body: Data? = nil, headers: [String: String]? = nil) throws -> Any? {
    try MCNetwork.jsonRequestExecute(method: method, urlString: urlString, body: body, headers: headers)
}

#endif
