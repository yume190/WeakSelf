//
//  WeakSelf.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/6.
//

import Foundation
import SwiftSyntax

public struct WeakSelf {
    
    public static func parse(source: String) throws {
        let sourceFile: SourceFileSyntax = try SyntaxParser.parse(source: source)
        self.parse(file: sourceFile)
    }
    
    public static func parse(url: URL) throws {
        let sourceFile: SourceFileSyntax = try SyntaxParser.parse(url)
        self.parse(file: sourceFile)
    }
    
    private static func parse(file: SourceFileSyntax) {
        var visitor = ClosureVisitor()
        file.walk(&visitor)

        print(visitor.closures.map{$0.description}.joined(separator: "\n"))
    }
}
