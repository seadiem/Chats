// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chat",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GamePacket",
            targets: ["GamePacket"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        
        .package( url: "https://github.com/seadiem/Files", .branch("AddDocumentsIOS")),
        .package( url: "https://github.com/IBM-Swift/BlueSocket.git", .branch("master"))
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        
        .target(
            name: "ChatYard",
            dependencies: ["Socket", "Files"]),
        
        
        // Demo Targets
        .target(
            name: "ChatClient",
            dependencies: ["ChatYard"]),
        .target(
            name: "ChatServer",
            dependencies: ["ChatYard", "Socket"]),
        .target(
            name: "Client",
            dependencies: ["ChatClient"]),
        .target(
            name: "Server",
            dependencies: ["ChatServer"]),
        
        
        // Game Packet and Runner
        .target(
            name: "GamePacket",
            dependencies: ["ChatYard", "Socket"]),
        .target(
            name: "GameRunner",
            dependencies: ["GamePacket"]),
        
    ]
)
