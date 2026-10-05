// swift-tools-version: 6.4

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
        .package(url: "https://github.com/swift-compositions/swift-http-router.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-coder.git", branch: "main", traits: ["Checkpoint", "Optic", "Skip", "Byte", "Operation", "Map"]),
        .package(url: "https://github.com/swift-atoms/swift-optic.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-3986.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-9110.git", branch: "main"),
        .package(url: "https://github.com/swift-compositions/swift-html.git", branch: "main"),
    ],
    targets: [
        // Domain module with all functionality
        .target(
            name: "Favicon",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "HTTP Router", package: "swift-http-router"),
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Optic", package: "swift-optic"),
                .product(name: "Case Macro", package: "swift-optic"),
                .product(name: "RFC 3986", package: "swift-rfc-3986"),
                .product(name: "HTML", package: "swift-html"),
            ]
        ),
        // Tests
        .testTarget(
            name: "FaviconTests",
            dependencies: [
                "Favicon",
                .product(name: "HTTP Router", package: "swift-http-router"),
                .product(name: "RFC 3986", package: "swift-rfc-3986"),
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
