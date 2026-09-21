// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RxReady",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "RxReady", targets: ["RxReady"]),
        .executable(name: "RxReadyDemo", targets: ["RxReadyDemo"])
    ],
    targets: [
        .target(name: "RxReady"),
        .executableTarget(name: "RxReadyDemo", dependencies: ["RxReady"]),
        .testTarget(name: "RxReadyTests", dependencies: ["RxReady"])
    ]
)
