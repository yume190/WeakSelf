//
//  IdentifierTests.swift
//  WeakSelfTests
//
//  Created by Yume on 2020/1/2.
//

import XCTest
import SwiftSyntax
@testable import WeakSelfKit

class IdentifierTests: XCTestCase {
    
    private final var visitor = Visitor<IdentifierExprSyntax>()
    
    override func setUp() {
        super.setUp()
        self.visitor.clear()
    }

    
    func testFunction() {
        let source = """
        print(a(b))
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs[0].text, "print")
        XCTAssertEqual(visitor.syntaxs[1].text, "a")
        XCTAssertEqual(visitor.syntaxs[2].text, "b")
    }
}
