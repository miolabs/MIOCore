import XCTest

@testable import MIOCore

final class MCStringTests: XCTestCase {

    func testReplacingWithParams() {
        XCTAssertEqual("Hi {{name}}".replacing(withParams: ["name": "Ana"]), "Hi Ana")
        XCTAssertEqual("{{a}}-{{b}}".replacing(withParams: ["a": "1", "b": "2"]), "1-2")
        XCTAssertEqual(
            "n={{n}}".replacing(withParams: ["n": 5]), "n={{n}}",
            "non-String values are left untouched")
        XCTAssertEqual("unchanged".replacing(withParams: nil), "unchanged")
    }

    func testCamelCaseToSnakeCase() {
        XCTAssertEqual("helloWorld".camelCaseToSnakeCase(), "hello_world")
        XCTAssertEqual(
            "MIOCore".camelCaseToSnakeCase(), "mio_core",
            "an acronym run breaks before a trailing lowercase letter")
        XCTAssertEqual("already".camelCaseToSnakeCase(), "already")
    }

    func testSnakeCaseToCamelCase() {
        XCTAssertEqual("hello_world".snakeCaseToCamelCase(), "helloWorld")
        XCTAssertEqual("one_two_three".snakeCaseToCamelCase(), "oneTwoThree")
        XCTAssertEqual("single".snakeCaseToCamelCase(), "single")
    }

    func testIntegerSubscripts() {
        let s = "hello"
        XCTAssertEqual(s[1], "e")
        XCTAssertEqual(s[1..<3], "el")
        XCTAssertEqual(s[1...3], "ell")
    }
}
