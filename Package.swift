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
        .package(url: "https://github.com/swift-kipple/Tools", .upToNextMinor(from: "0.2.3")),
    ],
    targets: [
        // Product Targets
        .target(
            name: "DocCMiddleware",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
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
