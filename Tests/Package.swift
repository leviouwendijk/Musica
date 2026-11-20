// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MusicaTests",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "mtest",
            targets: ["MusicaTestFlows"]
        ),
    ],
    dependencies: [
        // .package(url: "https://github.com/leviouwendijk/Methods.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/TestFlows.git", branch: "master"),
        .package(path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "MusicaTestFlows",
            dependencies: [
                .product(name: "Musica", package: "Musica"),
                // "Capture",
                .product(name: "TestFlows", package: "TestFlows"),
            ]
        ),
    ]
)

