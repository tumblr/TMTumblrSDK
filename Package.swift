// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TMTumblrSDK",
    products: [
        .library(
            name: "TMTumblrSDK",
            targets: ["TMTumblrSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "TMTumblrSDK",
            path: "Classes",
            exclude: ["ExampleiOS", "ExampleMacOS", "Framework"],
            resources: [
                .process("LICENSE"),
                .process("CHANGELOG.md"),
                .process("README.md"),
                .process("CONTRIBUTING.md"),
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
            ])
    ]
)
