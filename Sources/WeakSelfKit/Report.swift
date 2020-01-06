//
//  Report.swift
//  WeakSelfKit
//
//  Created by Yume on 2020/1/6.
//

import Foundation
import SwiftSyntax

//func findLocaiton(syntax: Syntax) -> SourceLocation? {
//    let position = context.sourceLocationConverter.location(for: syntax.positionAfterSkippingLeadingTrivia)
//    guard let line = position.line,
//        let column = position.column else {
//            return nil
//    }
//    return SourceLocation(path: context.filePath, line: line, column: column, offset: position.offset)
//}

//extension SourceLocationConverter {
//    func location(syntax: Syntax) -> SourceLocation? {
//        syntax.startLocation(converter: <#T##SourceLocationConverter#>)
////        self.locati
//        let position = self.location(for: syntax.positionAfterSkippingLeadingTrivia)
//        guard let line = position.line,
//            let column = position.column else {
//                return nil
//        }
//        return SourceLocation(path: context.filePath, line: line, column: column, offset: position.offset)
//    }
//}

public struct XcodeReporter {
    
    public func report(_ sources: [SourceDetail]) {
        let diagnosticEngine = makeDiagnosticEngine()
        for source in sources {
            let message = Diagnostic.Message(.warning, "Pecker: \(source.sourceKind) \(source.name) was never used; consider removing it")
            diagnosticEngine.diagnose(message, location: source.location.toSSLocation, actions: nil)
        }
    }
}

/// Makes and returns a new configured diagnostic engine.
private func makeDiagnosticEngine() -> DiagnosticEngine {
    let engine = DiagnosticEngine()
    let consumer = PrintingDiagnosticConsumer()
    engine.addConsumer(consumer)
    return engine
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// The kind of source code, we only check the follow kind
public enum SourceKind {
    case `class`
    case `struct`
    
    /// Contains function, instantsMethod, classMethod, staticMethod
    case function
    case `enum`
    case `protocol`
    case `typealias`
    case `operator`
    case `extension`
}

public struct SourceDetail {
    
    /// The name of the source, if any.
    public var name: String
    
    /// The kind of the source
    public var sourceKind: SourceKind
    
    /// The location of the source
    public var location: SourceLocation
}

extension SourceDetail: CustomStringConvertible {
    public var description: String {
        "\(name) | \(sourceKind) | \(location.description)"
    }
}

extension SourceDetail: Equatable {
    public static func == (lhs: SourceDetail, rhs: SourceDetail) -> Bool {
        lhs.name == rhs.name && lhs.location == rhs.location
    }
}

extension SourceDetail {
    var needFilterExtension: Bool {
        return sourceKind == .class ||
            sourceKind == .struct ||
            sourceKind == .enum ||
            sourceKind == .protocol
    }
}

extension SourceDetail {
    var identifier: String {
        return "\(location.path):\(location.line):\(location.column)"
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public typealias SSSourceLocation = SwiftSyntax.SourceLocation

public struct SourceLocation {
    public let path: String
    public let line: Int
    public let column: Int
    public let offset: Int
}

extension SourceLocation: CustomStringConvertible {
    public var description: String {
        "\(path):\(line):\(column)"
    }
}

extension SourceLocation: Equatable {
    public static func == (lhs: SourceLocation, rhs: SourceLocation) -> Bool {
        lhs.path == rhs.path && lhs.line == rhs.line && lhs.column == rhs.column
    }
}

extension SourceLocation {
    /// Converts a `SourceLocation` to a `SwiftSyntax.SourceLocation`.
    public var toSSLocation: SSSourceLocation {
        return SSSourceLocation(
            line: line,
            column: column,
            offset: offset,
            file: path)
    }
}
