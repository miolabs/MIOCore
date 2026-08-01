//
//  MIOCoreLexer.swift
//
//  Created by MIO Research Labs on 01/06/2020.
//

import Foundation
//import LoggerAPI

/// A single lexical token: its registered type and the matched text.
public struct MIOCoreLexerToken
{
    /// The token type identifier, as registered with ``MIOCoreLexer/addTokenType(_:regex:)``.
    public let type:Int
    /// The substring that matched.
    public let value:String
}

/// A small regex-driven tokenizer used by the SQL/query builders.
///
/// Register the token types you care about (each an integer tag + a regex), optionally mark some to
/// ignore (e.g. whitespace), then ``tokenize(withString:)`` an input and walk the results with
/// ``nextToken()`` / ``prevToken()``. Matching is greedy-first: at each position the first registered
/// type that matches wins, and the matched text is consumed.
///
/// ```swift
/// let lexer = MIOCoreLexer()
/// lexer.addTokenType(1, regex: try NSRegularExpression(pattern: "^[0-9]+"))
/// lexer.ignoreTokenType(0)
/// lexer.tokenize(withString: "42 7")
/// while let t = lexer.nextToken() { /* use t.type / t.value */ }
/// ```
public class MIOCoreLexer
{
    var inputString:String = ""
    var tokenTypes:[[String:Any]] = []
    var tokens:[MIOCoreLexerToken]!
    var tokenIndex = -1;

    var ignoreTokenTypes:[Int] = []

    /// Creates an empty lexer with no registered token types.
    public init() {}

    /// Registers a token type identified by `type` and recognized by `regex`.
    ///
    /// Registration order matters: during tokenizing the first matching type wins.
    ///
    /// - Parameters:
    ///   - type: An integer tag identifying this token type.
    ///   - regex: The pattern that recognizes it (typically anchored with `^`).
    public func addTokenType(_ type:Int, regex:NSRegularExpression) {
        var item:[String:Any] = [:]
        
        item["RegEx"] = regex
        item["Type"] = type
        
        tokenTypes.append(item)
    }

    /// Marks a token type to be matched but **not** emitted (e.g. whitespace or comments).
    ///
    /// - Parameter type: The token type tag to skip in the output stream.
    public func ignoreTokenType(_ type:Int) {
        ignoreTokenTypes.append(type)
    }

    /// Tokenizes an input string, populating the token stream and resetting the cursor to the start.
    ///
    /// Consumes the input left to right, emitting non-ignored matches. If no registered type matches
    /// at some position it logs a diagnostic and stops.
    ///
    /// - Parameter string: The input to tokenize.
    public func tokenize(withString string:String){
        inputString = string
        var input = string
        tokens = []
        var foundToken = false

        MIOCoreAutoReleasePool {
        
            repeat {
                foundToken = false
                for token in tokenTypes {
                    let regex = token["RegEx"] as! NSRegularExpression
                    let type = token["Type"] as! Int
                        
                    let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
                    if matches.count > 0 {
                        let range = matches[0].range
                        let start = input.index(input.startIndex, offsetBy: range.lowerBound)
                        let end = input.index(input.startIndex, offsetBy: range.upperBound)
                        
                        if ignoreTokenTypes.contains(type) == false {
                            let value = String(input[start..<end])
                            
                            let token = MIOCoreLexerToken(type: type, value: value)
                            tokens.append(token)
                        }
                        input.removeSubrange(start..<end)
                        foundToken = true
                        break
                    }
            }
            
            if (foundToken == false) {
                //throw new Error(`MIOCoreLexer: Token doesn't match any pattern. (${this.input})`);
                NSLog("[MIOCoreLexer] Token doesn't match any pattern. \(inputString) - Remaining: \(input)")
                break
            }
            
            } while (input.count > 0)
        }
    
        tokenIndex = 0
    }

    /// Returns the next token and advances the cursor, or `nil` at the end of the stream.
    ///
    /// - Returns: The token at the cursor, or `nil` if none remain.
    public func nextToken() -> MIOCoreLexerToken? {

        if tokenIndex >= tokens.count {
            return nil
        }

        let token = tokens[tokenIndex]
        tokenIndex += 1
        return token
        
        // Check if we have to ignore
//        let index = this.ignoreTokenTypes.indexOf(token.type);
//        return index == -1 ? token : this.nextToken();
    }
    
    /// Steps the cursor back one position and returns that token, or `nil` if before the start.
    ///
    /// Useful for one-token look-back while parsing.
    ///
    /// - Returns: The previous token, or `nil` if the cursor moved before the beginning.
    public func prevToken() -> MIOCoreLexerToken? {

        tokenIndex -= 1
        if tokenIndex < 0 {
            return nil
        }
        
        let token = tokens[tokenIndex]
                
        // Check if we have to ignore
//        let index = this.ignoreTokenTypes.indexOf(token.type);
//        return index == -1 ? token : this.prevToken();
        return token
    }
}

