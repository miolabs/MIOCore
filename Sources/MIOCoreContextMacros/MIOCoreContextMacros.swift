//
//  ContextVarMacro.swift
//
//
//  Created by Javier Segura Perez on 16/11/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


@main
struct MIOCoreContextPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ContextVarMacro.self,
    ]
}
