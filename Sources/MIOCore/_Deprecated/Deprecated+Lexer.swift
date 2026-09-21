//
//  Deprecated+Lexer.swift
//
//  Created by MIO Research Labs on 2026.
//
//  Previous lexer signatures. Use MCLexer instead. Kept as forwards so downstream keeps building.
//

import Foundation

@available(*, deprecated, renamed: "MCLexer")
public typealias MIOCoreLexer = MCLexer

@available(*, deprecated, renamed: "MCLexer.Token")
public typealias MIOCoreLexerToken = MCLexer.Token
