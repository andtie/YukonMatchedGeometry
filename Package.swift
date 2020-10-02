// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swiftlint:disable prefixed_toplevel_constant

import PackageDescription

let package = Package(
    name: "YukonMatchedGeometry",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        .library(
            name: "YukonMatchedGeometry",
            targets: ["YukonMatchedGeometry"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "YukonMatchedGeometry",
            dependencies: []
        )
    ]
)
