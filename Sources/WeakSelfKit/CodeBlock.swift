//
//  CodeBlock.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/2.
//

import Foundation
import SwiftSyntax

#warning(".tokens")
class CodeBlock {
    var origin: CodeBlockItemSyntax
    let `case`: Case
    init(origin: CodeBlockItemSyntax) {
        self.origin = origin
        
        let call = Call.gen(origin.item)
        let decl = Decl.gen(origin.item)
        
        self.case = call.case ?? decl.case ?? .unknown
    }
    
    indirect enum Call: CustomStringConvertible {
        case callID(id: String, args: [(String?, FunctionCallArgumentSyntax)])
        case callMember(member: String, args: [(String?, FunctionCallArgumentSyntax)])
        case callFunction(function: Call, args: [(String?, FunctionCallArgumentSyntax)])
        case unknown
        
        static func gen(_ function: Syntax?) -> Call {
            if let call = function as? FunctionCallExprSyntax {
                let args = call.argumentList.map { arg in
                    (arg.tokens.map{$0.text}.joined(separator: ""), arg)
                }
                
                if let id = call.calledExpression as? IdentifierExprSyntax {
                    let name = id.tokens.map{$0.text}.joined(separator: "")
                    return .callID(id: name, args: args)
                }
                if let member = call.calledExpression as? MemberAccessExprSyntax {
                    let name = member.tokens.map{$0.text}.joined(separator: "")
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
                return "\(id)(\(args.map{$0.0 ?? ""}.joined(separator: separator)))"
            case let .callMember(member, args):
                return "\(member)(\(args.map{$0.0 ?? ""}.joined(separator: separator)))"
            case let .callFunction(function, args):
                return "\(function)(\(args.map{$0.0 ?? ""}.joined(separator: separator)))"
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
    enum Decl: CustomStringConvertible {
        case declare(decl: String, id: String, eq: String?, value: String?)
        case assign
        case discard
        case unknown
        static func gen(_ decl: Syntax?) -> Decl {
            if let declSyntax = decl as? VariableDeclSyntax {
                let decl = declSyntax.letOrVarKeyword.text
                
                for binding in declSyntax.bindings {
                    let eq = binding.initializer?.equal.text // =
                    let value = binding.initializer?.value.tokens.map {$0.text}.joined(separator: " ") // 1
                    
                    if let pattern = binding.pattern as? IdentifierPatternSyntax {
                        let id = pattern.identifier.text
                        return .declare(decl: decl, id: id, eq: eq, value: value)
                    }
                }
            }
            if let seqSyntax = decl as? SequenceExprSyntax {
                seqSyntax.elements.filter {
                    return !($0 is DiscardAssignmentExprSyntax) && !($0 is AssignmentExprSyntax)
                }
            }
            
            return .unknown
        }
        
        var description: String {
            switch self {
            case let .declare(decl, id, eq, value):
                return "\(decl) \(id) \(eq ?? "") \(value ?? "")"
            default:
                return "unknown"
            }
        }
        var `case`: Case? {
            switch self {
            case .unknown: return nil
            default: return .declare(decl: self)
            }
        }
    }
    enum Other {
        case ifLet
        case guardLet
        case `defer`
    }
    
    enum Case: CustomStringConvertible {
        case functionCall(call: Call)
        case declare(decl: Decl)
        case unknown
        var description: String {
            switch self {
            case .functionCall(let call):
                return call.description
            case .declare(let decl):
                return decl.description
            default:
                return "unknown"
            }
        }
    }
}
