// swift-tools-version:5.5
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
        // Development
        .package(url: "https://github.com/swift-kipple/Tools", from: "0.2.1"),
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
                .product(name: "XCTVapor", package: "vapor"),
            ]
        ),
    ]
)

#if swift(>=5.6)
// Add swift-docc-plugin if possible.
package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
)
#endif
