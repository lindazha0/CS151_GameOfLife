// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Statistics",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Statistics",
            targets: ["Statistics"]
        ),
    ],
    dependencies: [
        .package(path: "../GameOfLife"),
        .package(path: "../Theming"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.4.2")
    ],
    targets: [
        .target(
            name: "Statistics",
            dependencies: [
                "GameOfLife",
                "Theming",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "StatisticsTests",
            dependencies: ["Statistics"]
        ),
    ]
)
