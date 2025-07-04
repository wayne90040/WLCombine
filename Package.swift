// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WLCombine",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "WLCombine", targets: ["WLCombine"]),
    ],
    targets: [
        .target(name: "WLCombine"),
        .target(name: "WLUIKitCombine"),
    ]
)
