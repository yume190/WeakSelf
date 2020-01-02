//
//  CodeBlockVisitorTests.swift
//  WeakSelfTests
//
//  Created by Yume on 2020/1/2.
//

import XCTest
import SwiftSyntax
@testable import WeakSelfKit

//print("a")
//BB.bb()
//_bb2.bb()
//_bb.bb()
//self?.bb()(self!)
//let ccc = self
//_ = self?.a
//_ = jjj
//_ = obj
//_ = a
//self?.a = 2
//if let ss1 = self {
//
//}
//guard let ss2 = self else {return}

class CodeBlockVisitorCallTests: XCTestCase {

    func testCallIDString() {
        let source = """
        print("a")
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
    
    func testCallIDInt() {
        let source = """
        print(1, 2, 3)
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
    
    func testCallIDVariable() {
        let source = """
        print(a)
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
    
    func testCallStatic() {
        let source = """
        Test.default()
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
    
    func testCallStaticVariable() {
        let source = """
        Test.default.call()
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
    
    func testCallFunction() {
        let source = """
        Test.closure(1)(2)(3)(4)
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }

}
