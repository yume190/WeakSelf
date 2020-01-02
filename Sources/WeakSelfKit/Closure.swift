//
//  Closure.swift
//  WeakSelf
//
//  Created by Yume on 2020/1/2.
//

import Foundation
import SwiftSyntax

public final class Closure: CustomStringConvertible {
    public var description: String {
        let caps = self.captures
            .map{ $0.description }
            .joined(separator: "\n\t- ")
        
        let _inputs = self.inputs
            .map{ $0.description }
            .joined(separator: "\n\t- ")
        return """
        Capture List:
        \t- \(caps)
        
        Input List:
        \t- \(_inputs)
        """
    }

    private var captures: [Capture] = []
    private var inputs: [Input] = []
    
    public func add(_ node: ClosureExprSyntax) {
        self.add(node.signature?.capture)
        self.add(node.signature?.input as? ParameterClauseSyntax)
    }
    
    private func add(_ input: ParameterClauseSyntax?) {
        let params = input?.parameterList.map {$0} ?? []
        for param in params {
            guard let name = param.firstName?.text else {continue}
            guard let theType = (param.type as? SimpleTypeIdentifierSyntax)?.name.text else {
                self.add(.withName(theName: name))
                continue
            }
            
            self.add(.withType(theName: name, theType: theType))
        }
    }
    
    private func add(_ input: Input) {
        self.inputs.append(input)
    }
    
    private func add(_ node: ClosureCaptureSignatureSyntax?) {
        let captures = node?.items?.map{$0} ?? []
        for cap in captures {
            guard let kind = cap.specifier?.firstToken?.text else {continue}
            guard let obj = cap.expression.firstToken?.text else {continue}
            guard let name = cap.name?.text else {
                self.add(.capture(kind: kind, name: obj))
                continue
            }
            self.add(.assign(kind: kind, name: name, obj: obj))
        }
    }
    
    private func add(_ capture: Capture) {
        self.captures.append(capture)
    }
}

extension Closure {
    enum Capture: CustomStringConvertible {
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
    }
}

extension Closure {
    enum Input: CustomStringConvertible {
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
