// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-favicon",
    platforms: [
        .macOS("27"),
        .iOS("27")
    ],
    products: [
        .library(name: "Favicon", targets: ["Favicon"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-compositions/swift-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-url-routing.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-html.git", branch: "main"),
    ],
    targets: [
        // Domain module with all functionality
        .target(
            name: "Favicon",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "URLRouting", package: "swift-url-routing"),
                // `router.url(for:)` returns a Foundation URL and now lives in the
                // Foundation Integration (url-routing 4087efbe extracted it);
                // MemberImportVisibility requires the defining module.
                .product(name: "URL Routing Foundation Integration", package: "swift-url-routing"),
                .product(name: "HTML", package: "swift-html"),
            ]
        ),
        // Tests
        .testTarget(
            name: "FaviconTests",
            dependencies: [
                "Favicon",
                .product(name: "URL Routing Foundation Integration", package: "swift-url-routing"),
                .product(name: "HTML", package: "swift-html"),
                .product(name: "Dependencies Test Support", package: "swift-dependencies"),
            ],
            exclude: ["Favicon.xctestplan"]
        ),
    ]
)

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("StrictUnsafe"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    // .unsafeFlags(["-warnings-as-errors"]),
    // .unsafeFlags([
    //   "-Xfrontend",
    //   "-warn-long-function-bodies=50",
    //   "-Xfrontend",
    //   "-warn-long-expression-type-checking=50",
    // ])
]

for index in package.targets.indices {
    package.targets[index].swiftSettings = (package.targets[index].swiftSettings ?? []) + swiftSettings
}
