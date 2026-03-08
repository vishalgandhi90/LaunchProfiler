// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LaunchProfiler",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "LaunchProfiler",
            targets: ["LaunchProfiler"]
        ),
    ],
    targets: [
        .target(
            name: "LaunchProfiler"
        ),
        .testTarget(
            name: "LaunchProfilerTests",
            dependencies: ["LaunchProfiler"]
        ),
    ]
)
