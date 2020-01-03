//
//  CodeBlockVisitorTests.swift
//  WeakSelfTests
//
//  Created by Yume on 2020/1/2.
//

import XCTest
import SwiftSyntax
@testable import WeakSelfKit

class MemberAccessTests: XCTestCase {
    
    private final var visitor = Visitor<MemberAccessExprSyntax>()
    
    override func setUp() {
        super.setUp()
        self.visitor.clear()
    }

    func testSelfA() {
        let source = """
        self.a = 1
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, "self")
        XCTAssertEqual(visitor.syntaxs.first?.nameText, "a")
    }
    
    func testSelfQA() {
        let source = """
        self?.a = 1
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, "self?")
        XCTAssertEqual(visitor.syntaxs.first?.nameText, "a")
    }
    
    func testAa() {
        let source = """
        A.a
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, "A")
        XCTAssertEqual(visitor.syntaxs.first?.nameText, "a")
    }
    
    func testAab() {
        let source = """
        A.a.b
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, "A.a")
        XCTAssertEqual(visitor.syntaxs.first?.nameText, "b")
    }
    
    func testAabFunction() {
        let source = """
        A.a.b()
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, "A.a")
        XCTAssertEqual(visitor.syntaxs.first?.nameText, "b")
    }
    
    func test1() {
        let source = """
        print(1)
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, nil)
        XCTAssertEqual(visitor.syntaxs.first?.nameText, nil)
    }
    
    func test2() {
        let source = """
        print(a)
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, nil)
        XCTAssertEqual(visitor.syntaxs.first?.nameText, nil)
    }
    
    func test3() {
        let source = """
        print(self.a)
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, "self")
        XCTAssertEqual(visitor.syntaxs.first?.nameText, "a")
    }
    
    func test4() {
        let source = """
        shuffle(self.a)
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, "self")
        XCTAssertEqual(visitor.syntaxs.first?.nameText, "a")
    }
    
    func test5() {
        let source = """
        a.shuffle(self.a)
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.syntaxs.first?.baseText, "a")
        XCTAssertEqual(visitor.syntaxs.first?.nameText, "shuffle")
        
        XCTAssertEqual(visitor.syntaxs.last?.baseText, "self")
        XCTAssertEqual(visitor.syntaxs.last?.nameText, "a")
    }
}
