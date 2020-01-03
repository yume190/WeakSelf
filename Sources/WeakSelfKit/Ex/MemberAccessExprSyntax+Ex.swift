//
//  MemberAccessExprSyntax+Ex.swift
//  SwiftSyntax
//
//  Created by Yume on 2020/1/3.
//

import Foundation
import SwiftSyntax

extension TokenSequence {
    var text: String {
        return self.map {$0.text}.joined(separator: "")
    }
}

extension MemberAccessExprSyntax {
    public var baseText: String? {
        return self.base?.tokens.text
    }
    
    public var nameText: String {
        return self.name.text
    }
}

extension IdentifierExprSyntax {
    public var text: String {
        self.tokens.text
    }
}
