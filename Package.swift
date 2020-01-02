// swift-tools-version:5.1
// Managed by ice

import PackageDescription

let package = Package(
    name: "WeakSelf",
    products: [
        .executable(name: "weakself", targets: ["WeakSelf"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50100.0")),
//        .package(url: "https://github.com/apple/indexstore-db.git", .branch("swift-5.1-branch")),
//        .package(url: "https://github.com/apple/swift-package-manager.git", .branch("master")),
//        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
    ],
    targets: [
        .target(name: "WeakSelf", dependencies: [
                "WeakSelfKit",
                "SwiftSyntax"
            ]
        ),
       .target(
           name: "WeakSelfKit",
           dependencies: [
               "SwiftSyntax",
//                "IndexStoreDB",
//                "TSCUtility",
//                "Yams"
           ]
       ),
        .testTarget(name: "WeakSelfTests", dependencies: ["WeakSelfKit"]),
    ]
)
