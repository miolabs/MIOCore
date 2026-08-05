//
//  MCMultipartRequest.swift
//
//  Created by MIO Research Labs on 07/06/2024.
//

import Foundation

/// Builds a `multipart/form-data` request body incrementally.
///
/// Add text fields and file parts, then read ``httpBody`` for the encoded body and
/// ``httpContentTypeHeadeValue`` for the matching `Content-Type` header (which carries the boundary).
///
/// ```swift
/// var form = MCMultipartRequest()
/// form.add(key: "title", value: "Receipt")
/// form.add(key: "file", fileName: "r.pdf", fileMimeType: "application/pdf", fileData: pdf)
/// var req = URLRequest(url: url)
/// req.httpMethod = "POST"
/// req.setValue(form.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
/// req.httpBody = form.httpBody
/// ```
public struct MCMultipartRequest {

    /// The multipart boundary token separating parts.
    public let boundary: String

    private let _separator: String = "\r\n"
    private var _data: Data

    /// Creates an empty multipart body.
    ///
    /// - Parameter boundary: The boundary token. Defaults to a fresh random UUID string.
    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self._data = .init()
    }

    private mutating func _append_boundary_separator() {
        _data.append("--\(boundary)\(_separator)")
    }

    private mutating func _append_separator() {
        _data.append(_separator)
    }

    private func _disposition(_ key: String) -> String {
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
        _append_boundary_separator()
        _data.append(_disposition(key) + _separator)
        _append_separator()
        _data.append(value + _separator)
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
        _append_boundary_separator()
        _data.append(_disposition(key) + "; filename=\"\(fileName)\"" + _separator)
        _data.append("Content-Type: \(fileMimeType)" + _separator + _separator)
        _data.append(fileData)
        _append_separator()
    }

    /// The `Content-Type` header value to send, including the boundary.
    public var httpContentTypeHeadeValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    /// The fully-assembled request body, terminated with the closing boundary.
    public var httpBody: Data {
        var body_data = _data
        body_data.append("--\(boundary)--")
        return body_data
    }
}
