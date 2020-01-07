//
//  CodeBlock+Decl.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/6.
//

import Foundation
import SwiftSyntax

extension CodeBlock {
    indirect enum Decl: CustomStringConvertible {
        enum BindingPattern: String {
            case `let`
            case `var`
            case unknown
        }
        
        struct Assign: CustomStringConvertible {
            let variable: AccessItem
            let value: AccessItem
            
            init?(syntax: PatternBindingSyntax) {
                guard let variableSyntax = syntax.pattern as? IdentifierPatternSyntax else {return nil}
                guard let valueSyntax = syntax.initializer?.value else {return nil}
                
                self.init(.gen(variableSyntax), .gen(valueSyntax))
            }
            
            init(_ variable: AccessItem, _ value: AccessItem) {
                self.variable = variable
                self.value = value
            }
            
            var description: String {
                return "\(variable.description) = \(value.description)"
            }
        }
        
        case declare(binding: BindingPattern, assign: Assign)
        case multiDeclare(binding: BindingPattern, assigns: [Assign])
        case assign(assign: Assign)
        case discard(value: AccessItem)
        case unknown
        
        static func gen(_ decl: Syntax?) -> Decl {
        
            if let declSyntax = decl as? VariableDeclSyntax {
                let bindingPattern = BindingPattern(rawValue: declSyntax.letOrVarKeyword.text) ?? .unknown
                let assigns = declSyntax.bindings.compactMap(Assign.init(syntax:))
                
                if declSyntax.bindings.count == 1 {
                    return .declare(binding: bindingPattern, assign: assigns[0])
                } else {
                    return .multiDeclare(binding: bindingPattern, assigns: assigns)
                }
            }
            
            if let seqSyntax = decl as? SequenceExprSyntax {
//                let isContainDiscard = seqSyntax.elements.contains { (syntax) -> Bool in
//                    return syntax is DiscardAssignmentExprSyntax
//
//                }
                
                let syntaxs = seqSyntax.elements.map{$0}
                guard let first = syntaxs.first else {return .unknown}
                guard let last = syntaxs.last else {return .unknown}
                if first is DiscardAssignmentExprSyntax {
                    return .discard(value: .gen(last))
                } else {
                    return .assign(assign: .init(.gen(first), .gen(last)))
                }
//
//                let syntax = seqSyntax.elements.filter {
//                    return !($0 is DiscardAssignmentExprSyntax) && !($0 is AssignmentExprSyntax)
//                }.first
//
//                guard isContainDiscard else { return .unknown }
//                guard let _syntax = syntax else { return .unknown }
//
//                return .discard(value: AccessItem.gen(_syntax))
            }
            
            return .unknown
        }
        
        var description: String {
            switch self {
            case let .declare(binding, assign):
                return "\(binding.rawValue) \(assign.description)"
            case let .multiDeclare(binding, assigns):
                return "\(binding.rawValue) \(assigns.map{$0.description}.joined(separator: " "))"
//            case let .declare(decl, id, eq, value):
//                return "\(decl) \(id) \(eq ?? "") \(value ?? "")"
            case let .assign(assign):
                return "\(assign.description)"
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
}
