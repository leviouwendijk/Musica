// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Musica",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Musica",
            targets: ["Musica"]
        ),
        .executable(
            name: "tuner",
            targets: ["tuner"]
        ),
        .executable(
            name: "mtest",
            targets: ["MusicaTestFlows"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/leviouwendijk/Capture.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Terminal.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Arguments.git", branch: "master"),
        // .package(url: "https://github.com/leviouwendijk/Methods.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/TestFlows.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "Musica",
        ),
        .executableTarget(
            name: "tuner",
            dependencies: [
                "Musica",
                "Capture",
                .product(name: "Terminal", package: "Terminal"),
                .product(name: "Arguments", package: "Arguments"),
                // .product(name: "Methods", package: "Methods"),
            ],
            path: "Sources/TunerCLI",
        ),
        .executableTarget(
            name: "MusicaTestFlows",
            dependencies: [
                "Musica",
                // "Capture",
                .product(name: "TestFlows", package: "TestFlows"),
            ]
        ),
    ]
)

