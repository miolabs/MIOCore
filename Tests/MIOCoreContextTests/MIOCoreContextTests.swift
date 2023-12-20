//
//  MIOCoreContextTests.swift
//
//
//  Created by Javier Segura Perez on 16/11/23.
//


import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(MIOCoreContextMacros)
import MIOCoreContextMacros

let testMacros: [String: Macro.Type] = [
    "ContextVar": ContextVarMacro.self,
]
#endif

final class MIOCoreContextTests: XCTestCase {
    func testMacro() throws {
        #if canImport(MIOCoreContextMacros)
        assertMacroExpansion(
            """
            @ContextVar var user:User
            """,
            expandedSource: """
            var user:User {
                get {
                   var v = globals[ "_user_key_" ] as? User
                   if v == nil {
                       v = User()
                       globals[ "_user_key_" ] = v
                   }
                   return v!
                }
                set {
                   globals[ "_user_key_" ] = newValue
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testOptionalMacro() throws {
        #if canImport(MIOCoreContextMacros)
        assertMacroExpansion(
            """
            @ContextVar var user:User?
            """,
            expandedSource: """
            var user:User? {
                get {
                   return globals[ "_user_key_" ] as? User
                }
                set {
                   globals[ "_user_key_" ] = newValue
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
