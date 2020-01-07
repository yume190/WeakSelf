//
//  CodeBlock.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/2.
//

import Foundation
import SwiftSyntax

class CodeBlock: Identifiable {
    let origin: CodeBlockItemSyntax
    let `case`: Case
    init(_ origin: CodeBlockItemSyntax) {
        self.origin = origin

        let call = Call(origin)
        let decl = Decl.gen(origin.item)
                
        self.case = call?.case ?? decl.case ?? .unknown
    }
    
    enum Other {
        case ifLet
        case guardLet
        case `defer`
    }
}

extension CodeBlock: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case declare
        case function
        case item
        case unknown
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self.case {
        case .declare(let decl):
            try container.encode(decl.description, forKey: .declare)
        case .functionCall(let call):
            try container.encode(call.identifiers, forKey: .function)
        case .item(let item):
            try container.encode(item.identifiers, forKey: .item)
        case .unknown:
            try container.encode("unknown", forKey: .unknown)
        }
    }
}
