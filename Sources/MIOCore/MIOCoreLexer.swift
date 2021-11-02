//
//  File.swift
//  
//
//  Created by Javier Segura Perez on 01/06/2020.
//

import Foundation
//import LoggerAPI

public struct MIOCoreLexerToken
{
    public let type:Int
    public let value:String
}

public class MIOCoreLexer
{
    var inputString:String = ""
    var tokenTypes:[[String:Any]] = []
    var tokens:[MIOCoreLexerToken]!
    var tokenIndex = -1;

    var ignoreTokenTypes:[Int] = []

    public init() {}
    
    public func addTokenType(_ type:Int, regex:NSRegularExpression) {
        var item:[String:Any] = [:]
        
        item["RegEx"] = regex
        item["Type"] = type
        
        tokenTypes.append(item)
    }

    public func ignoreTokenType(_ type:Int) {
        ignoreTokenTypes.append(type)
    }

    public func tokenize(withString string:String){
        inputString = string
        var input = string
        tokens = []
        var foundToken = false
    
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
    
        tokenIndex = 0
    }

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

