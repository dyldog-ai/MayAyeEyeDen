// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MayAyeEyeDen",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        // Shared library consumed by both the CLI tool and the macOS GUI app.
        .library(name: "MayAyeEyeDenCore", targets: ["MayAyeEyeDenCore"]),
        // Command-line tool entry point.
        .executable(name: "mayaeyedenden-cli", targets: ["mayaeyedenden-cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/apple-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "MayAyeEyeDenCore",
            dependencies: []
        ),
        .executableTarget(
            name: "mayaeyedenden-cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "apple-argument-parser"),
                .target(name: "MayAyeEyeDenCore"),
            ]
        ),
        .testTarget(
            name: "MayAyeEyeDenCoreTests",
            dependencies: ["MayAyeEyeDenCore"]
        ),
    ]
)
