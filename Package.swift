// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "ExpressLibrary",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/OperatorFoundation/Chord", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/Datable", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/Gardener", branch: "main"),
        .package(url: "https://github.com/armadsen/ORSSerialPort.git", from: "2.1.0"),
        .package(url: "https://github.com/OperatorFoundation/Straw", branch: "main"),
    ],
    targets: [
        .target(
            name: "ExpressLibrary",
            dependencies: [
                "Chord",
                "Datable",
                "Gardener",
                .product(name: "ORSSerial", package: "ORSSerialPort"),
                "Straw",
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .testTarget(name: "ExpressLibraryTests", dependencies: [
            .target(name: "ExpressLibrary"),
        ])
    ]
)
