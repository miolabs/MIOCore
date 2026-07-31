//
//  Multipart.swift
//
//
//  Created by Javier Segura Perez on 7/6/24.
//  https://theswiftdev.com/easy-multipart-file-upload-for-swift/
//

import Foundation

public extension Data {

    /// Appends the encoded bytes of a string to the receiver.
    ///
    /// A convenience used when assembling multipart bodies. Silently does nothing if `string` cannot
    /// be encoded with `encoding`.
    ///
    /// - Parameters:
    ///   - string: The text to append.
    ///   - encoding: The encoding to use. Defaults to `.utf8`.
    mutating func append(
        _ string: String,
        encoding: String.Encoding = .utf8
    ) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
}

/// Builds a `multipart/form-data` request body incrementally.
///
/// Add text fields and file parts, then read ``httpBody`` for the encoded body and
/// ``httpContentTypeHeadeValue`` for the matching `Content-Type` header (which carries the boundary).
///
/// ```swift
/// var form = MultipartRequest()
/// form.add(key: "title", value: "Receipt")
/// form.add(key: "file", fileName: "r.pdf", fileMimeType: "application/pdf", fileData: pdf)
/// var req = URLRequest(url: url)
/// req.httpMethod = "POST"
/// req.setValue(form.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
/// req.httpBody = form.httpBody
/// ```
public struct MultipartRequest {

    /// The multipart boundary token separating parts.
    public let boundary: String

    private let separator: String = "\r\n"
    private var data: Data

    /// Creates an empty multipart body.
    ///
    /// - Parameter boundary: The boundary token. Defaults to a fresh random UUID string.
    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self.data = .init()
    }
    
    private mutating func appendBoundarySeparator() {
        data.append("--\(boundary)\(separator)")
    }
    
    private mutating func appendSeparator() {
        data.append(separator)
    }

    private func disposition(_ key: String) -> String {
        "Content-Disposition: form-data; name=\"\(key)\""
    }

    /// Adds a simple text form field.
    ///
    /// - Parameters:
    ///   - key: The field name.
    ///   - value: The field's text value.
    public mutating func add(
        key: String,
        value: String
    ) {
        appendBoundarySeparator()
        data.append(disposition(key) + separator)
        appendSeparator()
        data.append(value + separator)
    }

    /// Adds a file part with a filename and MIME type.
    ///
    /// - Parameters:
    ///   - key: The field name.
    ///   - fileName: The filename reported in the `Content-Disposition` header.
    ///   - fileMimeType: The part's `Content-Type` (e.g. `"application/pdf"`).
    ///   - fileData: The raw file bytes.
    public mutating func add(
        key: String,
        fileName: String,
        fileMimeType: String,
        fileData: Data
    ) {
        appendBoundarySeparator()
        data.append(disposition(key) + "; filename=\"\(fileName)\"" + separator)
        data.append("Content-Type: \(fileMimeType)" + separator + separator)
        data.append(fileData)
        appendSeparator()
    }

    /// The `Content-Type` header value to send, including the boundary.
    public var httpContentTypeHeadeValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    /// The fully-assembled request body, terminated with the closing boundary.
    public var httpBody: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--")
        return bodyData
    }
}
