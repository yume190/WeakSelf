//
//  TokenVisitor.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/2.
//

import Foundation
import SwiftSyntax

public class TokenVisitor: SyntaxAnyVisitor {
    var closures: [Closure] = []
    public init() {}
    public func visitAny(_ node: Syntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }
    public func visit(_ node: ClosureExprSyntax) -> SyntaxVisitorContinueKind {
        let closure = Closure.init()
        closure.add(node)
        self.closures.append(closure)
        let stats = node.statements.map{$0}
        
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
