//
//  Visitor.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/3.
//

import Foundation
import SwiftSyntax

public class Visitor<S: Syntax>: SyntaxAnyVisitor {
    public private(set) var syntaxs: [S] = []
    public init() {}
    public func visitAny(_ node: Syntax) -> SyntaxVisitorContinueKind {
        if let node = node as? S {
            self.syntaxs.append(node)
        }
        return .visitChildren
    }
    
    public func clear() {
        self.syntaxs.removeAll()
    }
}
