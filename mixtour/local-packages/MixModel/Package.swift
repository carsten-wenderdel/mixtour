// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MixModel",
    products: [
        .library(
            name: "MixModel",
            targets: ["MixModel"]),
    ],
    dependencies: [
        .package(name: "Core", path: "../Core")
    ],
    targets: [
        .target(
            name: "MixModel",
            dependencies: ["Core"]),
        .testTarget(
            name: "MixModelTests",
            dependencies: ["MixModel"]),
    ]
)
