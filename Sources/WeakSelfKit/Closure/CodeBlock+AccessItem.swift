//
//  CodeBlock+AccessItem.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/3.
//

import Foundation
import SwiftSyntax

extension CodeBlock {
    indirect enum AccessItem: CustomStringConvertible {
        case identifier(_ id: IdentifierExprSyntax, _ forced: Bool)
        case member(_ member: MemberAccessExprSyntax, _ forced: Bool)
        case function(_ call: Call, _ forced: Bool)
        #warning("closure")
        case closure(_ closure: Int, _ forced: Bool)
        case unknown
        
        static func gen(_ syntax: Syntax, isForced: Bool = false) -> AccessItem {
            if let id = syntax as? IdentifierExprSyntax {
                return .identifier(id, isForced)
            }
            if let member = syntax as? MemberAccessExprSyntax {
                return .member(member, isForced)
            }
            if let function = syntax as? FunctionCallExprSyntax {
                return .function(Call(function), isForced)
            }
            if let forced = syntax as? ForcedValueExprSyntax {
                return self.gen(forced.expression, isForced: true)
            }
            return .unknown
        }
        
        var description: String {
            switch self {
            case let .identifier(id, forced):
                return "\(id.identifier.text)\(forced ? "!" : "")"
            case let .member(member, forced):
                return "\(member.tokens.text)\(forced ? "!" : "")"
            case let .function(f, forced):
                return "\(f.description)\(forced ? "!" : "")"
            case .closure(_, _):
                return "closure"
            case .unknown:
                return "unknown"
            }
        }
        
        var identifiers: [String] {
            switch self {
            case .identifier(_, _), .member(_, _):
                return [self.description]
            case let .function(f, _):
                //            return f.call.identifiers + f.args.flatMap {$0.identifiers}
                //            return "\(f.description)\(forced ? "!" : "")"
                return f.identifiers
            case .closure(_, _):
                return []//"clo"
            case .unknown:
                return []
            }
        }
        
        var `case`: Case? {
            return .item(item: self)
        }
    }
}
