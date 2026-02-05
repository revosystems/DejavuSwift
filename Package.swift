// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DejavuSwift",
    platforms: [.iOS(.v14), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DejavuSwift",
            targets: ["DejavuSwift"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DejavuSwift",
            resources: [
                .process("Resources/Assets.xcassets") // Include the .xcassets here
            ]
        ),
        .testTarget(
            name: "DejavuSwiftTests",
            dependencies: ["DejavuSwift"]
        ),
    ],
    swiftLanguageModes: [.v5, .v6]
)
