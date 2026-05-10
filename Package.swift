// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BopoBoard",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "BopoBoard",
            targets: ["BopoBoard"]
        )
    ],
    targets: [
        .target(
            name: "BopoBoardCore",
            path: "BopoBoardCore"
        ),
        .executableTarget(
            name: "BopoBoard",
            dependencies: ["BopoBoardCore"],
            path: "BopoBoard",
            exclude: [
                "Resources/Assets.xcassets"
            ],
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        ),
        .testTarget(
            name: "BopoBoardTests",
            dependencies: ["BopoBoardCore"],
            path: "Tests/BopoBoardTests"
        )
    ]
)
