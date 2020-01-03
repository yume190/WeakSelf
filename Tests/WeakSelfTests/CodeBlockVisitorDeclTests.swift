//
//  CodeBlockVisitorDeclTests.swift
//  WeakSelfTests
//
//  Created by Yume on 2020/1/2.
//

import XCTest
import SwiftSyntax
@testable import WeakSelfKit

class CodeBlockVisitorDeclTests: XCTestCase {
    
    func testDeclTuple1() {
        let source = """
        let (a,b) = (1, 2)
        """
        
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
    
    func testDeclTuple2() {
        let source = """
        let c = (1, 2)
        """
        
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
//        "let c = ( 1 , 2 )")"
//        "let c = (1, 2)")"
    }
    
    func testDeclMore() {
        let source = """
        let a = 1, b = 2
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
    
    func testDeclLet() {
        let source = """
        let a = 1
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
    
    func testDeclVar() {
        let source = """
        var a = 1
        """
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
    
    func testDeclDiscard() {
        let source = """
        _ = a
        """
        
        let sourceFile = try! SyntaxParser.parse(source: source)
        
        var visitor = CodeBlockVisitor()
        sourceFile.walk(&visitor)
        XCTAssertEqual(visitor.codeBlocks.first?.case.description, source)
    }
}
