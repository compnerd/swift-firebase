// swift-tools-version:5.9

import PackageDescription

let SwiftFirebase =
    Package(name: "SwiftFirebase",
            platforms: [
              .macOS(.v13)
            ],
            products: [
              .library(name: "FirebaseCore", targets: ["FirebaseCore"]),
              .library(name: "FirebaseAuth", targets: ["FirebaseAuth"]),
              .executable(name: "FireBaseUI", targets: ["FireBaseUI"]),
            ],
            dependencies: [
              .package(url: "https://github.com/compnerd/swift-win32", branch: "main"),
            ],
            targets: [
              .target(name: "firebase",
                      publicHeadersPath: "include",
                      cSettings: [
                        .unsafeFlags([
                          "-iapinotes-modules", "Sources/firebase/include",
                        ]),
                        .headerSearchPath("../../third_party/firebase-development/usr/include"),
                      ],
                      cxxSettings: [
                        .define("__swift__"),
                        .define("INTERNAL_EXPERIMENTAL"),
                        .define("_CRT_SECURE_NO_WARNINGS",
                                .when(platforms: [.windows])),
                      ]),
              .target(name: "FirebaseCore",
                      dependencies: ["firebase"],
                      cxxSettings: [
                        .define("INTERNAL_EXPERIMENTAL"),
                        .define("_CRT_SECURE_NO_WARNINGS",
                                .when(platforms: [.windows])),
                        .headerSearchPath("../../third_party/firebase-development/usr/include"),
                      ],
                      swiftSettings: [
                        .interoperabilityMode(.Cxx),
                      ]),
              .target(name: "FirebaseAuth",
                      dependencies: ["firebase", "FirebaseCore"],
                      cxxSettings: [
                        .define("INTERNAL_EXPERIMENTAL"),
                        .define("_CRT_SECURE_NO_WARNINGS",
                                .when(platforms: [.windows])),
                        .headerSearchPath("../../third_party/firebase-development/usr/include"),
                      ],
                      swiftSettings: [
                        .interoperabilityMode(.Cxx),
                      ]),
              .executableTarget(name: "FireBaseUI",
                                dependencies: [
                                  "FirebaseCore",
                                  "FirebaseAuth",
                                  .product(name: "SwiftWin32", package: "swift-win32"),
                                ],
                                path: "Examples/FireBaseUI",
                                resources: [.copy("Resources")],
                                packageAccess: false,
                                cSettings: [
                                  .unsafeFlags([
                                    "-iapinotes-modules", "Sources/firebase/include",
                                  ]),
                                ],
                                cxxSettings: [
                                  .define("INTERNAL_EXPERIMENTAL"),
                                  .define("_CRT_SECURE_NO_WARNINGS", .when(platforms: [.windows])),
                                ],
                                swiftSettings: [
                                  .interoperabilityMode(.Cxx),
                                  .unsafeFlags(["-parse-as-library"])
                                ],
                                linkerSettings: [
                                  .unsafeFlags([
                                    "-Lthird_party/firebase-development/usr/libs/windows",
                                    "-Lthird_party/firebase-development/usr/libs/windows/deps/app",
                                    "-Lthird_party/firebase-development/usr/libs/windows/deps/app/external",
                                  ]),
                                  .linkedLibrary("crypto"),
                                  .linkedLibrary("firebase_rest_lib"),
                                  .linkedLibrary("flatbuffers"),
                                  .linkedLibrary("libcurl"),
                                  .linkedLibrary("ssl"),
                                  .linkedLibrary("zlibstatic"),
                                ])
            ])
