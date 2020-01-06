//
//  CodeBlock+Case.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/6.
//

import Foundation

extension CodeBlock {
    enum Case: CustomStringConvertible {
        case functionCall(call: Call)
        case declare(decl: Decl)
        case item(item: AccessItem)
        case unknown
        var description: String {
            switch self {
            case .functionCall(let call):
                return call.description
            case .declare(let decl):
                return decl.description
            case .item(let item):
                return item.description
            default:
                return "unknown"
            }
        }
    }
}
