// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Muppet",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Muppet", targets: ["Muppet"]),
        .executable(name: "MuppetServer", targets: ["MuppetServer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/vapor.git", revision: "5861bf9e2cff2c4cb0dcfb0c15ecfaa8bc5630e0"), // 4.55.3
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Muppet", dependencies: []),
        .executableTarget(
            name: "MuppetServer",
            dependencies: ["Muppet", .product(name: "Vapor", package: "vapor")],
            swiftSettings: [.unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))]
        ),
    ]
)
