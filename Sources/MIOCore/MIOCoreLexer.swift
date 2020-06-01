//
//  File.swift
//  
//
//  Created by Javier Segura Perez on 01/06/2020.
//

import Foundation
/*
public class MIOCoreLexer
{
    let input:String
    var tokenTypes:[[String:Any]] = []
    var tokens:[Any]?
    var tokenIndex = -1;

    var ignoreTokenTypes:[Int] = []

    init(withString string:String) {
        input = string
    }

    func addTokenType(_ type:Int, regex:NSRegularExpression) {
        var item:[String:Any] = [:]
        
        item["RegEx"] = regex
        item["Type"] = type
        
        tokenTypes.append(item)
    }

    func ignoreTokenType(_ type:Int) {
        ignoreTokenTypes.append(type)
    }

    func tokenize() {
        //tokens = _tokenize()
        tokenIndex = 0
    }

    func _tokenize() -> [Any]{
        
        var tokens:[Any] = []
        var foundToken = false
    
        repeat {
            foundToken = false
            for token in tokenTypes {
                let regex = token["RegEx"] as! NSRegularExpression
                let type = token["Type"] as! Int
    
                let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.count))
                if matches.count > 0 {
                    if ignoreTokenTypes.contains(type) == false {
                        let match:[String:Any] = [:]
                        match["Type"] = type
                        match["Value"] = match[0].str
                        tokens.push({ type: type, value: matches[0], matches : matches});
                    }
                    input = this.input.substring(matches[0].length);
                    foundToken = true
                    break
                }
            }
            
            if (foundToken == false) {
                throw new Error(`MIOCoreLexer: Token doesn't match any pattern. (${this.input})`);
            }
            
        } while (input.count > 0)
    
        return tokens
    }

    func nextToken(){

        if (this.tokenIndex >= this.tokens.length) {
            return null;
        }

        let token = this.tokens[this.tokenIndex];
        this.tokenIndex++;

        // Check if we have to ignore
        let index = this.ignoreTokenTypes.indexOf(token.type);
        return index == -1 ? token : this.nextToken();
    }
    
    prevToken(){

        this.tokenIndex--;
        if (this.tokenIndex < 0) {
            return null;
        }
        
        let token = this.tokens[this.tokenIndex];

        // Check if we have to ignore
        let index = this.ignoreTokenTypes.indexOf(token.type);
        return index == -1 ? token : this.prevToken();
    }
}
*/
