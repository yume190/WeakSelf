//
//  CodeBlock.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/2.
//

import Foundation
import SwiftSyntax

class CodeBlock {
    var origin: CodeBlockItemSyntax
    let `case`: Case
    init(_ origin: CodeBlockItemSyntax) {
        self.origin = origin
        
        let call = Call.gen(origin.item)
        let decl = Decl.gen(origin.item)
        let call2 = Call2(origin.item)
        
        self.case = call.case ?? decl.case ?? .unknown
    }
    
    enum Decl: CustomStringConvertible {
        case declare(decl: String, id: String, eq: String?, value: String?)
        case multiDeclare(decl: String, pair: [(id: String, value: String)], eq: String?)
        case assign
        case discard(value: String)
        case unknown
        static func gen(_ decl: Syntax?) -> Decl {
            if let declSyntax = decl as? VariableDeclSyntax {
                let decl = declSyntax.letOrVarKeyword.text
                
                if declSyntax.bindings.count == 1 {
                    for binding in declSyntax.bindings {
                        let eq = binding.initializer?.equal.text // =
                        let value = binding.initializer?.value.tokens.map {$0.text}.joined(separator: " ") // 1
                        
                        if let pattern = binding.pattern as? IdentifierPatternSyntax {
                            let id = pattern.identifier.text
                            return .declare(decl: decl, id: id, eq: eq, value: value)
                        }
                    }
                } else {
                    
                }
                
            }
            if let seqSyntax = decl as? SequenceExprSyntax {
                let discard = seqSyntax.elements
                    .map {$0}
                    .filter {
                        return $0 is DiscardAssignmentExprSyntax
                    }.first
                guard let _ = discard else { return .unknown }
                let exprs = seqSyntax.elements.filter {
                    return !($0 is DiscardAssignmentExprSyntax) && !($0 is AssignmentExprSyntax)
                }
                let text = exprs.map{$0.tokens.text}.joined(separator: "")
                
                return .discard(value: text)
            }
            
            return .unknown
        }
        
        var description: String {
            switch self {
            case let .declare(decl, id, eq, value):
                return "\(decl) \(id) \(eq ?? "") \(value ?? "")"
            case let .discard(value):
                return "_ = \(value)"
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
