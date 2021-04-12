//
//  File.swift
//  
//
//  Created by David Trallero on 31/03/2021.
//

import Foundation

import XCTest

@testable import DualLinkDB

final class StringReplacingTests: XCTestCase {
    func testStringReplacing( ) {
        XCTAssertTrue( "hello world".replacing( "hello", with: "bye" ) == "bye world", "fails replacing first word" )
        XCTAssertTrue( "life is hard".replacing( "hard", with: "nice" ) == "life is nice", "fails replacing last word" )
        XCTAssertTrue( "bye cruel world".replacing( "cruel", with: "bye" ) == "bye bye world", "fails replacing middle word" )

        XCTAssertTrue( "manana".replacing( "a", with: "e" ) == "menene", "fails just one character" )
        XCTAssertTrue( "ahahaha".replacing( "a", with: "e" ) == "ehehehe", "fails just one character - edge cases" )
    }
}
