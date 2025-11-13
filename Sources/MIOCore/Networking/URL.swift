//
//  URL.swift
//
//
//  Created by Javier Segura Perez on 17/10/21.
//

import Foundation

#if !os(WASI)

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public func MIOCoreURLDataRequest(_ request:URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    
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
    let session = URLSession( configuration: config )
    
    let task = session.dataTask(with: request, completionHandler: {
        data, response, error in
        
        if error != nil {
            print(error!.localizedDescription)
        }
        
        completion(data, response, error)
    })
    
    task.resume()
}

public func MIOCoreURLDataRequest_sync(_ request:URLRequest) throws -> Data? {
    
    let config = URLSessionConfiguration.ephemeral
    config.timeoutIntervalForRequest = 240    
//    config.requestCachePolicy = .reloadIgnoringLocalCacheData
//    config.urlCache = nil

    let session = URLSession.init(configuration: config)
    
    let (data, _, error) = session.synchronousDataTask(with: request)
                     
    if error != nil {
        print("ERROR MIOCoreURLDataRequest_sync: \(error!.localizedDescription)")
        print("ERROR Request: \(request)")
        print("ERROR Body: \(request.httpBody ?? Data())")
        throw error!
    }
    
    // TODO: Check response code

    return data
}

public func MIOCoreURLJSONRequest(_ request:URLRequest, completion: @escaping ([String:Any]?, Error?) -> Void) {
                    
    var r = request
    r.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    MIOCoreURLDataRequest(r) {
        data, response, error in

        if error != nil {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
            DispatchQueue.main.async {
                completion(json, nil)
            }
            return
        }
        catch let error {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
    }
}

public func MIOCoreURLJSONRequest_sync( _ request:URLRequest ) throws -> Any? {
                    
    var r = request
    
    if r.value(forHTTPHeaderField: "Content-Type") == nil {
        r.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    let data = try MIOCoreURLDataRequest_sync(r)
    if data == nil { return nil }
    
    let json = try JSONSerialization.jsonObject(with: data!, options: [])
    return json
}

extension URLRequest
{
    public init( method:String = "GET", urlString: String, body:Data? = nil, headers:[String:String]? = nil, mimeType:String? = nil ) {
        self.init(url: URL(string:  urlString)!)
        httpMethod = method
        httpBody = body
        if mimeType != nil { setValue( mimeType!, forHTTPHeaderField: "Content-Type" ) }
        if headers != nil {
            for (key, value) in headers! { setValue(value, forHTTPHeaderField: key) }
        }
    }
}

public func MIOCoreURLJSONRequestExecute( method:String = "GET", urlString: String, body:[ String: Any ]? = nil, headers:[String:String]? = nil ) throws -> Any? {
    
    let data = body != nil ? try MIOCoreJsonValue(withJSONObject: body!, options: [] ) : nil
    return try MIOCoreURLJSONRequestExecute(method: method, urlString: urlString, body: data, headers: headers)
}

public func MIOCoreURLJSONRequestExecute( method:String = "GET", urlString: String, body:Data? = nil, headers:[String:String]? = nil ) throws -> Any? {
    
    let data = body
    var r = URLRequest( method: method, urlString: urlString, body: data )
    if headers != nil {
        for (key, value) in headers! { r.setValue(value, forHTTPHeaderField: key) }
    }
    return try MIOCoreURLJSONRequest_sync( r ) as? [ String:Any ]
}

//public func MIOCoreURLFileRequest(_ request:URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
//
//    var r = request
//    r.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//
//    MIOCoreURLDataRequest(r, completion: completion)
//}
#endif
