import Foundation
import SwiftSyntax
import WeakSelfKit

class A {
    var a: Int = 1
    func bb() -> (A) -> Void {
        let obj = A()
        let weakC: (A) -> Void = { [weak self, unowned jjj = obj] (a: A) in //() -> Int in
            print(self?.a)
            self?.bb()(self!)
            _ = self?.a
            _ = jjj
            _ = obj
            _ = a
            self?.a = 2
            if let ss1 = self {
                
            }
            guard let ss2 = self else {return}
        }
        
        let unownedC: () -> Void = { [unowned self] in //() -> Int in
            _ = self.a
        }
        
        let strongC: () -> Void = {  //() -> Int in
            _ = self.a
        }
        
        return weakC
    }
}

//        seqExpr
//

//        MemberAccessExprSyntax            如: self?.a BB.BB
//            OptionalChainingExprSyntax
//                IdentifierExprSyntax

// FunctionCallExpr
//     IdentifierExprSyntax|MemberAccessExprSyntax|FunctionCallExpr
//     FunctionCallArgumentListSyntax
/*
 CodeBlockItemSyntax                        print(self?.a)
 FunctionCallExprSyntax                 print
 FunctionCallArgumentListSyntax
 [FunctionCallArgumentSyntax]          self?.a
 */



let sourceFile = try SyntaxParser.parse(source: source)
//let x = FindPublicExtensionDeclVisitor().visit(sourceFile)

var visitor = ClosureVisitor()
sourceFile.walk(&visitor)
//print(x)

print(visitor.closures.map{$0.description}.joined(separator: "\n"))
