// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Simulation",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Simulation",
            targets: ["Simulation"]
        ),
    ],
    dependencies: [
        .package(path: "../Grid"),
        .package(path: "../GameOfLife"),
        .package(path: "../Theming"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.4.2")
    ],
    targets: [
        .target(
            name: "Simulation",
            dependencies: [
                "Grid",
                "Theming",
                "GameOfLife",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "SimulationTests",
            dependencies: ["Simulation"]
        ),
    ]
)
