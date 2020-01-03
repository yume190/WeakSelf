//
//  CodeBlock+Call.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/3.
//

import Foundation
import SwiftSyntax

extension CodeBlock {
    struct Call2 {
        let callExpr: AccessItem
        let argumentList: [AccessItem]
        init?(_ syntax: Syntax) {
            guard let syntax = syntax as? FunctionCallExprSyntax else { return nil }
            self.callExpr = .gen(syntax.calledExpression)
            self.argumentList = syntax.argumentList.map {.gen($0)}
        }
    }
    indirect enum Call: CustomStringConvertible {
        case callID(id: String, args: [String?])
        case callMember(member: String, args: [String?])
        case callFunction(function: Call, args: [String?])
        case unknown
        
        static func gen(_ function: Syntax?) -> Call {
            if let call = function as? FunctionCallExprSyntax {
                let args = call.argumentList.map { arg in
                    arg.tokens.map{$0.text}.joined(separator: "")
                }
                
                if let id = call.calledExpression as? IdentifierExprSyntax {
                    let name = id.tokens.text
                    return .callID(id: name, args: args)
                }
                if let member = call.calledExpression as? MemberAccessExprSyntax {
                    let name = member.tokens.text
                    return .callID(id: name, args: args)
                }
                if let function = call.calledExpression as? FunctionCallExprSyntax {
                    return .callFunction(function: Call.gen(function), args: args)
                }
            }
            return .unknown
        }
        
        var description: String {
            let separator = " "
            switch self {
            case let .callID(id, args):
                return "\(id)(\(args.map{$0 ?? ""}.joined(separator: separator)))"
            case let .callMember(member, args):
                return "\(member)(\(args.map{$0 ?? ""}.joined(separator: separator)))"
            case let .callFunction(function, args):
                return "\(function)(\(args.map{$0 ?? ""}.joined(separator: separator)))"
            case .unknown:
                return "unknown"
            }
        }
        var `case`: Case? {
            switch self {
            case .unknown: return nil
            default: return .functionCall(call: self)
            }
        }
    }
}
