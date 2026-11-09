// swift-tools-version:6.1
//
// A minimal MIOCoreWasm module, used by test.mjs to check the Swift / JS convention.
//   swiftly run swift build --swift-sdk swift-6.3.3-RELEASE_wasm -c release +6.3.3
//   node test.mjs .build/release/Example.wasm

import PackageDescription

let package = Package(
    name: "Example",
    dependencies: [ .package( path: "../.." ) ],
    targets: [
        .executableTarget(
            name: "Example",
            dependencies: [ .product( name: "MIOCoreWasm", package: "MIOCore" ) ],
            linkerSettings: [ .unsafeFlags( [ "-Xclang-linker", "-mexec-model=reactor", "-Xlinker", "--strip-debug" ], .when( platforms: [.wasi] ) ) ]
        ),
    ]
)
