//
//  CodeBlock+AccessItem.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/3.
//

import Foundation
import SwiftSyntax

extension CodeBlock {
    enum AccessItem: CustomStringConvertible {
        case id(id: IdentifierPatternSyntax)
        case member(member: MemberAccessExprSyntax)
        case call(call: Call)
        #warning("closure")
        case closure(closure: Int)
        case unknown
        
        static func gen(_ syntax: Syntax) -> AccessItem {
            if let id = syntax as? IdentifierPatternSyntax {
                return .id(id: id)
            }
            if let member = syntax as? MemberAccessExprSyntax {
                return .member(member: member)
            }
            return .unknown
        }
        
        var description: String {
            switch self {
            case let .id(id):
                return "\(id.tokens.text)"
            case let .member(member):
                return "\(member.tokens.text)"
            case .unknown:
                return "unknown"
            default:
                return "not define"
            }
        }
//        var `case`: Case? {
//            switch self {
//            case .unknown: return nil
//            default: return .functionCall(call: self)
//            }
//        }
    }
}
