// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Widgeteer",
    products: [
        .library(
            name: "Widgeteer",
            targets: ["Widgeteer"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Widgeteer",
            dependencies: []
        ),
        .target(
            name: "DartApiDl",
            dependencies: []
        ),
    ]
)
