// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
//import CompilerPluginSupport

let package = Package(
    name: "MIOCore",
    platforms: [.iOS(.v12), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library( name: "MIOCoreContext", targets: [ "MIOCoreContext" ] ),
        .library( name: "MIOCore", targets: [ "MIOCore" ] ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        //.systemLibrary(name: "TimeLib", pkgConfig: "TimeLib"),
        .target( name: "MIOCore", dependencies: [] ),
        .target( name: "MIOCoreContext", dependencies: [] ),
        .testTarget(
            name: "MIOCoreTests",
            dependencies: ["MIOCore"]
        ),
        .testTarget(
            name: "MIOCoreContextTests",
            dependencies: ["MIOCoreContext"]
        ),

    ]
)
