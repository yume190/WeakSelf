//
//  CodeBlockVisitor.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/2.
//

import Foundation
import SwiftSyntax

//public class CodeBlockVisitor: SyntaxAnyVisitor {
//    var codeBlocks: [CodeBlock] = []
//    public init() {}
//    public func visitAny(_ node: Syntax) -> SyntaxVisitorContinueKind {
//        return .visitChildren
//    }
//    public func visit(_ node: CodeBlockItemSyntax) -> SyntaxVisitorContinueKind {
//        self.codeBlocks.append(.init(node))
//        return .visitChildren
//    }
//}

public class CodeBlockVisitor: Visitor<CodeBlockItemSyntax> {
    var codeBlocks: [CodeBlock] {
        return self.syntaxs.map { (node: CodeBlockItemSyntax) -> CodeBlock in
            return CodeBlock(node)
        }
    }
}
