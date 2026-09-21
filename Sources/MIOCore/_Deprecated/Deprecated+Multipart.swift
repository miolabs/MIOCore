//
//  Deprecated+Multipart.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous multipart signatures. Use MCMultipartRequest instead. Kept as forwards so downstream keeps building.
//

import Foundation

@available(*, deprecated, renamed: "MCMultipartRequest")
public typealias MultipartRequest = MCMultipartRequest
