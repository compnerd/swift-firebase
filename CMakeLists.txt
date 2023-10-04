# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.25)
project(swift-firebase
  LANGUAGES Swift)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)

include(FetchContent)

option(SWIFT_FIREBASE_BUILD_EXAMPLES "Build example UI" TRUE)

# ${TOOLCHAIN_ROOT}/usr/include allows us to access swift C++ interop headers.
cmake_path(GET CMAKE_Swift_COMPILER PARENT_PATH _SWIFT_INCLUDE_DIR)
cmake_path(GET _SWIFT_INCLUDE_DIR PARENT_PATH _SWIFT_INCLUDE_DIR)
include_directories(SYSTEM ${_SWIFT_INCLUDE_DIR}/include)

add_library(firebase INTERFACE)
target_compile_options(firebase INTERFACE
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xcc -DSR69711>"
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xcc -DINTERNAL_EXPERIMENTAL>")
target_include_directories(firebase INTERFACE
  Sources/firebase/include
  third_party/firebase-development/usr/include)
target_link_directories(firebase INTERFACE
  third_party/firebase-development/usr/libs/windows
  third_party/firebase-development/usr/libs/windows/deps/app
  third_party/firebase-development/usr/libs/windows/deps/app/external)

add_library(FirebaseCore SHARED
  Sources/FirebaseCore/FirebaseApp+Swift.swift
  Sources/FirebaseCore/FirebaseConfiguration.swift
  Sources/FirebaseCore/FirebaseError.swift
  Sources/FirebaseCore/FirebaseLogging+Swift.swift
  Sources/FirebaseCore/FirebaseOptions+Swift.swift
  Sources/FirebaseCore/FutureProtocol.swift)
target_compile_options(FirebaseCore PRIVATE
  -cxx-interoperability-mode=default)
target_link_libraries(FirebaseCore PUBLIC
  firebase)
target_link_libraries(FirebaseCore PRIVATE
  libcurl
  firebase_app
  flatbuffers
  zlibstatic)

add_library(FirebaseAuth SHARED
  Sources/FirebaseAuth/AuthStateDidChangeListenerHandle.swift
  Sources/FirebaseAuth/FIRActionCodeOperation.swift
  Sources/FirebaseAuth/FIRAuthTokenResult.swift
  Sources/FirebaseAuth/FirebaseAuth+Swift.swift
  Sources/FirebaseAuth/FirebaseAuthError.swift
  Sources/FirebaseAuth/FirebaseAuthResult+Swift.swift
  Sources/FirebaseAuth/FirebaseUser+Swift.swift)
target_compile_options(FirebaseAuth PRIVATE
  -cxx-interoperability-mode=default)
target_link_libraries(FirebaseAuth PUBLIC
  firebase
  FirebaseCore)
target_link_libraries(FirebaseAuth PRIVATE
  crypto
  firebase_rest_lib
  flatbuffers
  libcurl
  ssl
  zlibstatic)

add_library(FirebaseFirestore SHARED
  Sources/FirebaseFirestore/Vendor/Codable/CodableErrors.swift
  Sources/FirebaseFirestore/Vendor/Codable/CodablePassThroughTypes.swift
  Sources/FirebaseFirestore/Vendor/Codable/DocumentID.swift
  Sources/FirebaseFirestore/Vendor/FirebaseDataEncoder/FirebaseDataEncoder.swift
  Sources/FirebaseFirestore/Vendor/FirebaseDataEncoder/FirebaseRemoteConfigValueDecoding.swift
  Sources/FirebaseFirestore/CollectionReference+Swift.swift
  Sources/FirebaseFirestore/DocumentChange+Swift.swift
  Sources/FirebaseFirestore/DocumentReference+Swift.swift
  Sources/FirebaseFirestore/DocumentSnapshot+Swift.swift
  Sources/FirebaseFirestore/FieldValue+Swift.swift
  Sources/FirebaseFirestore/Firestore+Swift.swift
  Sources/FirebaseFirestore/FirestoreDataConverter.swift
  Sources/FirebaseFirestore/FirestoreErrorCode.swift
  Sources/FirebaseFirestore/FirestoreSource+Swift.swift
  Sources/FirebaseFirestore/ListenerRegistration.swift
  Sources/FirebaseFirestore/Query+Swift.swift
  Sources/FirebaseFirestore/QueryDocumentSnapshot.swift
  Sources/FirebaseFirestore/QuerySnapshot+Swift.swift
  Sources/FirebaseFirestore/Settings+Swift.swift
  Sources/FirebaseFirestore/SnapshotMetadata+Swift.swift
  Sources/FirebaseFirestore/Timestamp+Swift.swift
  Sources/FirebaseFirestore/Transaction+Swift.swift
  Sources/FirebaseFirestore/TransactionOptions+Swift.swift
  Sources/FirebaseFirestore/WriteBatch+Swift.swift)
target_compile_options(FirebaseFirestore PRIVATE
  -cxx-interoperability-mode=default)
target_link_libraries(FirebaseFirestore PUBLIC
  firebase
  FirebaseCore)
target_link_libraries(FirebaseFirestore PRIVATE
  absl_bad_optional_access
  absl_bad_variant_access
  absl_base
  absl_city
  absl_cord
  absl_cord_internal
  absl_cordz_functions
  absl_cordz_handle
  absl_cordz_info
  absl_graphcycles_internal
  absl_hash
  absl_int128
  absl_low_level_hash
  absl_malloc_internal
  absl_random_internal_platform
  absl_random_internal_pool_urbg
  absl_random_internal_randen
  absl_random_internal_randen_hwaes
  absl_random_internal_randen_hwaes_impl
  absl_random_internal_randen_slow
  absl_random_internal_seed_material
  absl_random_seed_gen_exception
  absl_raw_hash_set
  absl_raw_logging_internal
  absl_spinlock_wait
  absl_stacktrace
  absl_status
  absl_statusor
  absl_str_format_internal
  absl_strerror
  absl_strings
  absl_strings_internal
  absl_symbolize
  absl_synchronization
  absl_throw_delegate
  absl_time
  absl_time_zone
  address_sorting
  cares
  crypto
  firestore_core
  firestore_nanopb
  firestore_protos_nanopb
  firebase_rest_lib
  firestore_util
  flatbuffers
  gpr
  grpc
  grpc++
  leveldb
  libcurl
  protobuf-nanopb
  re2
  snappy
  ssl
  upb
  zlibstatic)

if(SWIFT_FIREBASE_BUILD_EXAMPLES)
  FetchContent_Declare(SwiftWin32
    GIT_REPOSITORY https://github.com/compnerd/swift-win32
    GIT_TAG 07e91e67e86f173743329c6753d9e66ac4727830) # Pinned for reproducibility and before Package@swift-#.#.swift symlinks
  FetchContent_MakeAvailable(SwiftWin32)

  add_executable(FireBaseUI
    Examples/FireBaseUI/FireBaseUI.swift
    Examples/FireBaseUI/FireBaseUIViewController.swift
    Examples/FireBaseUI/FirestoreTestingViewController.swift
    Examples/FireBaseUI/SceneDelegate.swift
    Examples/FireBaseUI/SwiftWin32+Extensions.swift)
  target_compile_options(FireBaseUI PRIVATE
    -parse-as-library
    -cxx-interoperability-mode=default)
  target_link_libraries(FireBaseUI PRIVATE
    FirebaseCore
    FirebaseAuth
    FirebaseFirestore
    SwiftWin32)
  add_custom_command(TARGET FireBaseUI POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Examples/FireBaseUI/Resources $<TARGET_FILE_DIR:FireBaseUI>/Resources
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Examples/FireBaseUI/Info.plist $<TARGET_FILE_DIR:FireBaseUI>/Info.plist
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Examples/FireBaseUI/$<TARGET_FILE_NAME:FireBaseUI>.manifest $<TARGET_FILE_DIR:FireBaseUI>/$<TARGET_FILE_NAME:FireBaseUI>.manifest)
endif()
