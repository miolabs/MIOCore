//
//  Data+Extension.swift
//
//  Created by MIO Research Labs on 07/06/2024.
//

import Foundation

extension Data {

    /// Appends the encoded bytes of a string to the receiver.
    ///
    /// A convenience used when assembling multipart bodies. Silently does nothing if `string` cannot
    /// be encoded with `encoding`.
    ///
    /// - Parameters:
    ///   - string: The text to append.
    ///   - encoding: The encoding to use. Defaults to `.utf8`.
    public mutating func append(
        _ string: String,
        encoding: String.Encoding = .utf8
    ) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
}
