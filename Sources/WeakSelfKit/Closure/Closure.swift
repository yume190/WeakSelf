//
//  Closure.swift
//  WeakSelf
//
//  Created by Yume on 2020/1/2.
//

import Foundation
import SwiftSyntax
import Yams

public class Closure: CustomStringConvertible, Encodable {
    
    enum CodingKeys: String, CodingKey {
        case captures = "Capture List"
        case inputs = "Input List"
        case codeBlocks = "Code Block List"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if captures.count != 0 {
            try container.encode(captures, forKey: .captures)
        }

        if inputs.count != 0 {
            try container.encode(inputs, forKey: .inputs)
        }
        
        if codeBlocks.count != 0 {
            try container.encode(codeBlocks, forKey: .codeBlocks)
        }
    }
    
    public var yaml: String {
        let yaml = (try? YAMLEncoder().encode(self)) ?? ""
        return yaml == "{}" ? "" : yaml
    }
    
    public var description: String {
        return self.yaml
    }

    private var captures: [Capture] = []
    private var inputs: [Input] = []
    private var codeBlocks: [CodeBlock]
    
    public init(_ node: ClosureExprSyntax) {
        self.captures = Self.add(node.signature?.capture)
        self.inputs = Self.add(node.signature?.input as? ParameterClauseSyntax)
        self.codeBlocks = node.statements.map {CodeBlock($0)}
    }
    
    private static func add(_ input: ParameterClauseSyntax?) -> [Input] {
        guard let params = input?.parameterList else {return []}

        var inputs = [Input]()
        for param in params {
            guard let name = param.firstName?.text else {continue}
            guard let theType = (param.type as? SimpleTypeIdentifierSyntax)?.name.text else {
                inputs.append(.withName(theName: name))
                continue
            }
            
            inputs.append(.withType(theName: name, theType: theType))
        }
        return inputs
    }
    
    private static func add(_ node: ClosureCaptureSignatureSyntax?) -> [Capture] {
        guard let captureSyntaxs = node?.items else { return [] }
        
        var captures = [Capture]()
        for cap in captureSyntaxs {
            guard let kind = cap.specifier?.firstToken?.text else {continue}
            guard let obj = cap.expression.firstToken?.text else {continue}
            guard let name = cap.name?.text else {
                captures.append(.capture(kind: kind, name: obj))
                continue
            }
            captures.append(.assign(kind: kind, name: name, obj: obj))
        }
        return captures
    }
}

extension Closure {
    enum Capture: CustomStringConvertible, Encodable, Identifierable {
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.description)
        }
        
        case capture(kind: String, name: String)
        case assign(kind: String, name: String, obj: String)
        var description: String {
            switch self {
            case let .capture(kind, name):
                return "\(kind) \(name)"
            case let .assign(kind, name, obj):
                return "\(kind) \(name) = \(obj)"
            }
        }
        
        var identifiers: [String] {
            switch self {
            case .capture(_, let name), .assign(_, let name, _):
                return [name]
            }
        }
    }
}

extension Closure {
    enum Input: CustomStringConvertible, Encodable, Identifierable {
        var identifiers: [String] {
            switch self {
            case .withName(let name), .withType(let name, _):
                return [name]
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.description)
        }
        
        case withName(theName: String)
        case withType(theName: String, theType: String)
        var description: String {
            switch self {
            case let .withName(theName):
                return "\(theName)"
            case let .withType(theName, theType):
                return "\(theName): \(theType)"
            }
        }
    }
}
