// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MixUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "MixUI",
            targets: ["MixUI"]),
    ],
    dependencies: [
        .package(name: "Core", path: "../Core"),
        .package(name: "MixModel", path: "../MixModel"),
    ],
    targets: [
        .target(
            name: "MixUI",
            dependencies: ["Core", "MixModel"]),
        .testTarget(
            name: "MixUITests",
            dependencies: ["MixUI"]),
    ]
)
