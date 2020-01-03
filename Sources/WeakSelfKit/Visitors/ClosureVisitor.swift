//
//  ClosureVisitor.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/2.
//

import Foundation
import SwiftSyntax

//public class ClosureVisitor: SyntaxAnyVisitor {
//    public var closures: [Closure] {
//        return self.syntaxs.map { (node: ClosureExprSyntax) -> Closure in
//            return Closure(node)
//        }
//    }
//    private var syntaxs: [ClosureExprSyntax] = []
//    public init() {}
//    public func visitAny(_ node: Syntax) -> SyntaxVisitorContinueKind {
//        return .visitChildren
//    }
//    public func visit(_ node: ClosureExprSyntax) -> SyntaxVisitorContinueKind {
//        self.syntaxs.append(node)
//        return .visitChildren
//    }
//}

public class ClosureVisitor: Visitor<ClosureExprSyntax> {
    public var closures: [Closure] {
        return self.syntaxs.map { (node: ClosureExprSyntax) -> Closure in
            return Closure(node)
        }
    }    
}
