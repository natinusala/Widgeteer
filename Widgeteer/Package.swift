// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Widgeteer",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Widgeteer",
            targets: ["Widgeteer"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/wickwirew/Runtime", .upToNextMajor(from: "2.2.4")),
        .package(url: "https://github.com/swift-server/swift-backtrace", .upToNextMajor(from: "1.3.3")),
    ],
    targets: [
        .target(
            name: "Widgeteer",
            dependencies: [
                "DartApiDl",
                "Runtime",
                .product(name: "Backtrace", package: "swift-backtrace"),
            ]
        ),
        .target(
            name: "DartApiDl",
            dependencies: []
        ),
    ]
)
