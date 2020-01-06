//
//  CodeBlock+Call.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/3.
//

import Foundation
import SwiftSyntax

extension CodeBlock {
    struct Call {
        let callExpr: AccessItem
        let argumentList: [AccessItem]
        
        init(_ syntax: FunctionCallExprSyntax) {
            self.callExpr = .gen(syntax.calledExpression)
            self.argumentList = syntax.argumentList.map{.gen($0.expression)}
        }
        
        init?(_ syntax: CodeBlockItemSyntax) {
            guard let _syntax = syntax.item as? FunctionCallExprSyntax else {return nil}
            self.init(_syntax)
        }
        
        var description: String {
            return """
            \(callExpr.description)(\(argumentList.map{$0.description}.joined(separator: ", ")))
            """
        }
        
        var identifiers: [String] {
            return self.callExpr.identifiers + self.argumentList.flatMap {$0.identifiers}
        }
        
        var `case`: Case {
            return .functionCall(call: self)
        }
    }
}
