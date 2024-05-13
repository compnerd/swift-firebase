// swift-tools-version:5.9

import PackageDescription
import Foundation
import WinSDK

let swiftc = "swiftc.exe".withCString(encodedAs: UTF16.self) { pwszCompiler in
  let dwLength = SearchPathW(nil, pwszCompiler, nil, 0, nil, nil)
  return withUnsafeTemporaryAllocation(of: WCHAR.self, capacity: Int(dwLength) + 1) {
    _ = SearchPathW(nil, pwszCompiler, nil, dwLength + 1, $0.baseAddress, nil)
    return String(decodingCString: $0.baseAddress!, as: UTF16.self)
  }
}
let include = URL(fileURLWithPath: swiftc).deletingLastPathComponent()
                                          .deletingLastPathComponent()
                                          .appendingPathComponent("include")
                                          .withUnsafeFileSystemRepresentation {
  String(cString: $0!)
}

let SwiftFirebase =
    Package(name: "SwiftFirebase",
            platforms: [
              .macOS(.v13)
            ],
            products: [
              .library(name: "FirebaseCore", targets: ["FirebaseCore"]),
              .library(name: "FirebaseAuth", targets: ["FirebaseAuth"]),
              .library(name: "FirebaseFirestore", targets: ["FirebaseFirestore"]),
              .library(name: "FirebaseFunctions", targets: ["FirebaseFunctions"]),
              .executable(name: "FireBaseUI", targets: ["FireBaseUI"]),
            ],
            dependencies: [
              // This revision is important since it's the first one before the swift-win32 repo moved to versioned symlinks
              // for different swift-tools-versions.
              .package(url: "https://github.com/compnerd/swift-win32", revision: "07e91e67e86f173743329c6753d9e66ac4727830"),
            ],
            targets: [
              .target(name: "firebase",
                      publicHeadersPath: "include",
                      cSettings: [
                        .headerSearchPath("../../third_party/firebase-development/usr/include"),
                        .unsafeFlags(["-I", include]),
                      ],
                      cxxSettings: [
                        .define("__swift__"),
                        .define("INTERNAL_EXPERIMENTAL"),
                        .define("_CRT_SECURE_NO_WARNINGS",
                                .when(platforms: [.windows])),
                        .unsafeFlags(["-I", include]),
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
                        .unsafeFlags(["-Xcc", "-I\(include)"]),
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
                        .unsafeFlags(["-Xcc", "-I\(include)"]),
                      ]),
              .target(name: "FirebaseFirestore",
                      dependencies: ["firebase", "FirebaseCore"],
                      exclude: [
                        "vendor/README.md",
                        "vendor/LICENSE"
                      ],
                      cxxSettings: [
                        .define("SR69711"),
                        .define("INTERNAL_EXPERIMENTAL"),
                        .define("_CRT_SECURE_NO_WARNINGS",
                                .when(platforms: [.windows])),
                        .headerSearchPath("../../third_party/firebase-development/usr/include"),
                      ],
                      swiftSettings: [
                        .interoperabilityMode(.Cxx),
                        .unsafeFlags(["-Xcc", "-I\(include)"]),
                      ],
                      linkerSettings: [
                        .unsafeFlags([
                          "-Lthird_party/firebase-development/usr/libs/windows",
                          "-Lthird_party/firebase-development/usr/libs/windows/deps/app",
                          "-Lthird_party/firebase-development/usr/libs/windows/deps/app/external",
                        ]),
                        .linkedLibrary("absl_bad_optional_access"),
                        .linkedLibrary("absl_bad_variant_access"),
                        .linkedLibrary("absl_base"),
                        .linkedLibrary("absl_city"),
                        .linkedLibrary("absl_cord"),
                        .linkedLibrary("absl_cord_internal"),
                        .linkedLibrary("absl_cordz_functions"),
                        .linkedLibrary("absl_cordz_handle"),
                        .linkedLibrary("absl_cordz_info"),
                        .linkedLibrary("absl_crc_cord_state"),
                        .linkedLibrary("absl_crc_cpu_detect"),
                        .linkedLibrary("absl_crc_internal"),
                        .linkedLibrary("absl_crc32c"),
                        .linkedLibrary("absl_flags_commandlineflag_internal"),
                        .linkedLibrary("absl_flags_commandlineflag"),
                        .linkedLibrary("absl_flags_config"),
                        .linkedLibrary("absl_flags_internal"),
                        .linkedLibrary("absl_flags_marshalling"),
                        .linkedLibrary("absl_flags_private_handle_accessor"),
                        .linkedLibrary("absl_flags_program_name"),
                        .linkedLibrary("absl_flags_reflection"),
                        .linkedLibrary("absl_graphcycles_internal"),
                        .linkedLibrary("absl_hash"),
                        .linkedLibrary("absl_int128"),
                        .linkedLibrary("absl_kernel_timeout_internal"),
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
                        .linkedLibrary("absl_string_view"),
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
                        .linkedLibrary("upb_base_lib"),
                        .linkedLibrary("upb_json_lib"),
                        .linkedLibrary("upb_mem_lib"),
                        .linkedLibrary("upb_message_lib"),
                        .linkedLibrary("upb_textformat_lib"),
                        .linkedLibrary("utf8_range_lib"),
                        .linkedLibrary("utf8_validity"),
                      ]),
              .target(name: "FirebaseFunctions",
                      dependencies: ["firebase", "FirebaseCore"],
                      cxxSettings: [
                        .define("INTERNAL_EXPERIMENTAL"),
                        .define("_CRT_SECURE_NO_WARNINGS",
                                .when(platforms: [.windows])),
                        .headerSearchPath("../../third_party/firebase-development/usr/include"),
                      ],
                      swiftSettings: [
                        .interoperabilityMode(.Cxx),
                        .unsafeFlags(["-Xcc", "-I\(include)"]),
                      ]),
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
                                cxxSettings: [
                                  .define("INTERNAL_EXPERIMENTAL"),
                                  .define("_CRT_SECURE_NO_WARNINGS", .when(platforms: [.windows])),
                                ],
                                swiftSettings: [
                                  .interoperabilityMode(.Cxx),
                                  .unsafeFlags(["-parse-as-library"]),
                                  .unsafeFlags(["-Xcc", "-I\(include)"]),
                                ])
            ])
