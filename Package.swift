// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AbundanceDeposits",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "AbundanceDepositsLib",
            targets: ["AbundanceDepositsLib"]
        ),
    ],
    targets: [
        .target(
            name: "AbundanceDepositsLib",
            path: "AbundanceDeposits",
            exclude: ["App/Info.plist"]
        )
    ]
)
