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
              .library(name: "FirebaseFirestore", targets: ["FirebaseFirestore"]),
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
              .target(name: "FirebaseFirestore",
                      dependencies: ["firebase", "FirebaseCore"],
                      cxxSettings: [
                        .define("INTERNAL_EXPERIMENTAL"),
                        .define("_CRT_SECURE_NO_WARNINGS",
                                .when(platforms: [.windows])),
                        .headerSearchPath("../../third_party/firebase-development/usr/include"),
                      ],
                      swiftSettings: [
                        .interoperabilityMode(.Cxx),
                      ],
                      linkerSettings: [
                        .linkedLibrary("absl_bad_optional_access"),
                        .linkedLibrary("absl_bad_variant_access"),
                        .linkedLibrary("absl_base"),
                        .linkedLibrary("absl_city"),
                        .linkedLibrary("absl_cord"),
                        .linkedLibrary("absl_cord_internal"),
                        .linkedLibrary("absl_cordz_functions"),
                        .linkedLibrary("absl_cordz_handle"),
                        .linkedLibrary("absl_cordz_info"),
                        .linkedLibrary("absl_graphcycles_internal"),
                        .linkedLibrary("absl_hash"),
                        .linkedLibrary("absl_int128"),
                        .linkedLibrary("absl_low_level_hash"),
                        .linkedLibrary("absl_malloc_internal"),
                        .linkedLibrary("absl_random_internal_platform"),
                        .linkedLibrary("absl_random_internal_pool_urbg"),
                        .linkedLibrary("absl_random_internal_randen"),
                        .linkedLibrary("absl_random_internal_randen_hwaes"),
                        .linkedLibrary("absl_random_internal_randen_hwaes_impl"),
                        .linkedLibrary("absl_random_internal_randen_slow"),
                        .linkedLibrary("absl_random_internal_seed_material"),
                        .linkedLibrary("absl_random_seed_gen_exception"),
                        .linkedLibrary("absl_raw_hash_set"),
                        .linkedLibrary("absl_raw_logging_internal"),
                        .linkedLibrary("absl_spinlock_wait"),
                        .linkedLibrary("absl_stacktrace"),
                        .linkedLibrary("absl_status"),
                        .linkedLibrary("absl_statusor"),
                        .linkedLibrary("absl_str_format_internal"),
                        .linkedLibrary("absl_strerror"),
                        .linkedLibrary("absl_strings"),
                        .linkedLibrary("absl_strings_internal"),
                        .linkedLibrary("absl_symbolize"),
                        .linkedLibrary("absl_synchronization"),
                        .linkedLibrary("absl_throw_delegate"),
                        .linkedLibrary("absl_time"),
                        .linkedLibrary("absl_time_zone"),
                        .linkedLibrary("address_sorting"),
                        .linkedLibrary("cares"),
                        .linkedLibrary("firestore_core"),
                        .linkedLibrary("firestore_nanopb"),
                        .linkedLibrary("firestore_protos_nanopb"),
                        .linkedLibrary("firestore_util"),
                        .linkedLibrary("gpr"),
                        .linkedLibrary("grpc"),
                        .linkedLibrary("grpc++"),
                        .linkedLibrary("leveldb"),
                        .linkedLibrary("protobuf-nanopb"),
                        .linkedLibrary("re2"),
                        .linkedLibrary("snappy"),
                        .linkedLibrary("upb"),
                      ]
                      ),
              .executableTarget(name: "FireBaseUI",
                                dependencies: [
                                  "FirebaseCore",
                                  "FirebaseAuth",
                                  "FirebaseFirestore",
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
