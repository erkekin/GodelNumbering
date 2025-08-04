// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GodelNumbering",
    products: [
        .library(
            name: "GodelNumbering",
            targets: ["GodelNumbering"]),
    ],
    dependencies: [
      .package(url: "https://github.com/swift-tree/ExpressionTree.git", exact: "2.0.2")
    ],
    targets: [
        .target(
            name: "GodelNumbering",
            dependencies: ["ExpressionTree"]
            ),
        .testTarget(
            name: "GodelNumberingTests",
            dependencies: ["GodelNumbering", "ExpressionTree"]
          ),
    ]
)
