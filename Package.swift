// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TMTumblrSDK",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "TMTumblrSDK",
            targets: ["TMTumblrSDK"]),
    ],
    targets: [
        .target(
            name: "TMTumblrSDK",
            path: "Classes"),
        // TODO: - The tests are mixed objc/swift so we need to split them to make this work
        .testTarget(
            name: "TMTumblrSDKTests",
            dependencies: ["TMTumblrSDK"]
        ),
    ]
)
