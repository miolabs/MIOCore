//
//  File.swift
//  
//
//  Created by Javier Segura Perez on 01/06/2020.
//

import Foundation


open class MIOPredicate: NSObject
{
    public init(format predicateFormat: String, argumentArray arguments: [Any]?) {
        super.init()
        parse(predicateFormat, arguments: arguments)
    }
              
    public init(format predicateFormat: String, arguments argList: CVaListPointer) {
        
    }
    
    func parse(_ predicateFormat: String, arguments: [Any]?) {
        
    }
    /*
    func tokenize(withFormat format:string){
           
           this.lexer = new MIOCoreLexer(format);
           
           // Values
           
           this.lexer.addTokenType(MIOPredicateTokenType.UUIDValue, /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i);
           this.lexer.addTokenType(MIOPredicateTokenType.StringValue, /^"([^"]*)"|^'([^']*)'/);

           this.lexer.addTokenType(MIOPredicateTokenType.NumberValue, /^-?\d+(?:\.\d+)?(?:e[+\-]?\d+)?/i);
           this.lexer.addTokenType(MIOPredicateTokenType.BooleanValue, /^(true|false)/i);
           this.lexer.addTokenType(MIOPredicateTokenType.NullValue, /^(null|nil)/i);
           // Symbols
           this.lexer.addTokenType(MIOPredicateTokenType.OpenParenthesisSymbol, /^\(/);
           this.lexer.addTokenType(MIOPredicateTokenType.CloseParenthesisSymbol, /^\)/);
           // Comparators
           this.lexer.addTokenType(MIOPredicateTokenType.MinorOrEqualComparator, /^<=/);
           this.lexer.addTokenType(MIOPredicateTokenType.MinorComparator, /^</);
           this.lexer.addTokenType(MIOPredicateTokenType.MajorOrEqualComparator, /^>=/);
           this.lexer.addTokenType(MIOPredicateTokenType.MajorComparator, /^>/);
           this.lexer.addTokenType(MIOPredicateTokenType.EqualComparator, /^==?/);
           this.lexer.addTokenType(MIOPredicateTokenType.DistinctComparator, /^!=/);
           this.lexer.addTokenType(MIOPredicateTokenType.NotContainsComparator, /^not contains /i);
           this.lexer.addTokenType(MIOPredicateTokenType.ContainsComparator, /^contains /i);
           this.lexer.addTokenType(MIOPredicateTokenType.InComparator, /^in /i);
           // Bitwise operators
           this.lexer.addTokenType(MIOPredicateTokenType.BitwiseAND, /^& /i);
           this.lexer.addTokenType(MIOPredicateTokenType.BitwiseOR, /^\| /i);
           // Operations
           //this.lexer.addTokenType(MIOPredicateTokenType.MinusOperation, /^- /i);
           // Join operators
           this.lexer.addTokenType(MIOPredicateTokenType.AND, /^(and|&&) /i);
           this.lexer.addTokenType(MIOPredicateTokenType.OR, /^(or|\|\|) /i);
           // Relationship operators
           this.lexer.addTokenType(MIOPredicateTokenType.ANY, /^any /i);
           this.lexer.addTokenType(MIOPredicateTokenType.ALL, /^all /i);
           // Extra
           this.lexer.addTokenType(MIOPredicateTokenType.Whitespace, /^\s+/);
           this.lexer.ignoreTokenType(MIOPredicateTokenType.Whitespace);
           
           // Placeholder
           this.lexer.addTokenType(MIOPredicateTokenType.Class, /^%@/i);

           // Identifiers - Has to be the last one
           this.lexer.addTokenType(MIOPredicateTokenType.Identifier, /^[a-zA-Z-_][a-zA-Z0-9-_\.]);

           this.lexer.tokenize();
       }*/

}

extension MIOPredicate {
    
    public convenience init(format predicateFormat: String, _ args: CVarArg...) {
        self.init(format:predicateFormat, argumentArray:nil)
    }
}

