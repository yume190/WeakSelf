import Foundation
import SwiftSyntax
import WeakSelfKit








let sourceFile = try SyntaxParser.parse(source: source)
var visitor = ClosureVisitor()
sourceFile.walk(&visitor)

print(visitor.closures.map{$0.description}.joined(separator: "\n"))
