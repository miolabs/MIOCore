import XCTest

@testable import MIOCore

final class MCLexerTests: XCTestCase {

    private enum Tok: Int {
        case whitespace = 0
        case number = 1
        case word = 2
    }

    private func makeLexer() throws -> MCLexer {
        let lexer = MCLexer()
        // Anchored patterns: the first matching type at the cursor wins.
        lexer.addTokenType(Tok.number.rawValue, regex: try NSRegularExpression(pattern: "^[0-9]+"))
        lexer.addTokenType(Tok.word.rawValue, regex: try NSRegularExpression(pattern: "^[a-z]+"))
        lexer.addTokenType(Tok.whitespace.rawValue, regex: try NSRegularExpression(pattern: "^\\s+"))
        lexer.ignoreTokenType(Tok.whitespace.rawValue)
        return lexer
    }

    func testTokenizeEmitsTypedTokensSkippingIgnored() throws {
        let lexer = try makeLexer()
        lexer.tokenize(withString: "42 abc 7")

        var types: [Int] = []
        var values: [String] = []
        while let t = lexer.nextToken() {
            types.append(t.type)
            values.append(t.value)
        }

        XCTAssertEqual(values, ["42", "abc", "7"])
        XCTAssertEqual(types, [Tok.number.rawValue, Tok.word.rawValue, Tok.number.rawValue])
    }

    func testNextTokenReturnsNilAtEnd() throws {
        let lexer = try makeLexer()
        lexer.tokenize(withString: "1")
        XCTAssertNotNil(lexer.nextToken())
        XCTAssertNil(lexer.nextToken())
    }

    func testPrevTokenStepsBack() throws {
        let lexer = try makeLexer()
        lexer.tokenize(withString: "1 two")
        _ = lexer.nextToken()  // "1"
        _ = lexer.nextToken()  // "two"
        let back = lexer.prevToken()  // back to "two"
        XCTAssertEqual(back?.value, "two")
    }
}
