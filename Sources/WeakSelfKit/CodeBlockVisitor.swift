//
//  CodeBlockVisitor.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/2.
//

import Foundation
import SwiftSyntax

public class CodeBlockVisitor: SyntaxAnyVisitor {
    var codeBlocks: [CodeBlock] = []
    public init() {}
    public func visitAny(_ node: Syntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }
    public func visit(_ node: CodeBlockItemSyntax) -> SyntaxVisitorContinueKind {
        self.codeBlocks.append(.init(origin: node))
        
        
        //        varDecl
        //          PatternBindingList let a1 = a2
        //              PatternBinding
        //                  IDPattern  a1
        //                  InitClause a2
        
        //        seqExpr
        //
        
        //        MemberAccessExprSyntax            如: self?.a BB.BB
        //            OptionalChainingExprSyntax
        //                IdentifierExprSyntax
        
        // FunctionCallExpr
        //     IdentifierExprSyntax|MemberAccessExprSyntax|FunctionCallExpr
        //     FunctionCallArgumentListSyntax
        /*
         CodeBlockItemSyntax                        print(self?.a)
         FunctionCallExprSyntax                 print
         FunctionCallArgumentListSyntax
         [FunctionCallArgumentSyntax]          self?.a
         */
        return .visitChildren
    }
}
