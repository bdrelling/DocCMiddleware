// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "DocCMiddleware",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(name: "DocCMiddleware", targets: ["DocCMiddleware"]),
    ],
    dependencies: [
        // 💧 Vapor
        .package(url: "https://github.com/vapor/vapor", from: "4.65.1"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // Product Targets
        .target(
            name: "DocCMiddleware",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
        // Example
        // This target will be split from the repository once the core module is functioning properly.
        .executableTarget(
            name: "Example",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .target(name: "DocCMiddleware"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(
            name: "Example2",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        // Test Targets
        .testTarget(
            name: "DocCMiddlewareTests",
            dependencies: [
                .target(name: "DocCMiddleware"),
            ]
        ),
    ]
)
