// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Grid",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Grid",
            targets: ["Grid"]),
    ],
    dependencies: [
        .package(path: "../GameOfLife"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.4.2")
    ],
    targets: [
        .target(
            name: "Grid",
            dependencies: [
                "GameOfLife",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "GridTests",
            dependencies: ["Grid"]),
    ]
)
