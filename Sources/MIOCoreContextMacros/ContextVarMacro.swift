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

public struct ContextVarMacro: AccessorMacro
{
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
          let binding = varDecl.bindings.first,
          let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
          binding.accessorBlock == nil,
          let type = binding.typeAnnotation?.type
        else {
          return []
        }
        
        let key = "_\(identifier.text.lowercased())_key_"
        return [
               """
               get {
                  var v = _globals[ \(literal: key) ] as? \(type)
                  if v == nil {
                      v = \(type)()
                      _globals[ \(literal: key) ] = v
                  }
                  return v!
               }
               """,
               """
               set {
                  _globals[ \(literal: key) ] = newValue
               }
               """]
    }
}
