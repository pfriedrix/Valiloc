// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Vali",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Vali",
            targets: ["Vali"]
        )
    ],
    targets: [
        .target(
            name: "Vali"
        )
    ]
)
