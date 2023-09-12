# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.25)
project(swift-firebase
  LANGUAGES Swift)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)

include(FetchContent)

# Download The Firebase CPP SDK and extract it to disk
set(FIREBASE_CPP_SDK_VERSION "20230828.0")

message(${CMAKE_SOURCE_DIR})

include(FetchContent)
FetchContent_Declare(
    firebase_sdk
    URL "https://github.com/thebrowsercompany/firebase-cpp-sdk/releases/download/${FIREBASE_CPP_SDK_VERSION}/firebase-windows-amd64.zip"
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/downloads
    SOURCE_DIR "${CMAKE_SOURCE_DIR}/third_party/firebase-development/usr"
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)

FetchContent_MakeAvailable(firebase_sdk)

add_library(firebase INTERFACE)
target_compile_options(firebase INTERFACE
  "SHELL:$<$<COMPILE_LANGUAGE:Swift>:-Xcc -DINTERNAL_EXPERIMENTAL>")
target_include_directories(firebase INTERFACE
  Sources/firebase/include
  third_party/firebase-development/usr/include)
target_link_directories(firebase INTERFACE
  third_party/firebase-development/usr/libs/windows
  third_party/firebase-development/usr/libs/windows/deps/app
  third_party/firebase-development/usr/libs/windows/deps/app/external)
target_link_libraries(firebase INTERFACE
  crypto
  firebase_rest_lib
  flatbuffers
  libcurl
  ssl
  zlibstatic)

add_library(FirebaseCore
  Sources/FirebaseCore/FirebaseApp+Swift.swift
  Sources/FirebaseCore/FirebaseConfiguration.swift
  Sources/FirebaseCore/FirebaseError.swift
  Sources/FirebaseCore/FirebaseLogging+Swift.swift
  Sources/FirebaseCore/FirebaseOptions+Swift.swift)
target_compile_options(FirebaseCore PRIVATE
  -cxx-interoperability-mode=default)
target_link_libraries(FirebaseCore PRIVATE
  firebase)

add_library(FirebaseAuth
  Sources/FirebaseAuth/FIRActionCodeOperation.swift
  Sources/FirebaseAuth/FIRAuthTokenResult.swift
  Sources/FirebaseAuth/FirebaseAuth+Swift.swift
  Sources/FirebaseAuth/FirebaseAuthError.swift
  Sources/FirebaseAuth/FirebaseAuthResult+Swift.swift
  Sources/FirebaseAuth/FirebaseUser+Swift.swift)
target_compile_options(FirebaseAuth PRIVATE
  -cxx-interoperability-mode=default)
target_link_libraries(FirebaseAuth PUBLIC
  FirebaseCore)
target_link_libraries(FirebaseAuth PRIVATE
  firebase)

FetchContent_Declare(SwiftWin32
  GIT_REPOSITORY https://github.com/compnerd/swift-win32
  GIT_TAG main)
FetchContent_MakeAvailable(SwiftWin32)

add_executable(FireBaseUI
  Examples/FireBaseUI/FireBaseUI.swift
  Examples/FireBaseUI/FireBaseUIViewController.swift
  Examples/FireBaseUI/SceneDelegate.swift
  Examples/FireBaseUI/SwiftWin32+Extensions.swift)
target_compile_options(FireBaseUI PRIVATE
  -cxx-interoperability-mode=default)
target_link_libraries(FireBaseUI PRIVATE
  firebase
  FirebaseCore
  FirebaseAuth
  SwiftWin32)
add_custom_command(TARGET FireBaseUI POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Examples/FireBaseUI/Resources $<TARGET_FILE_DIR:FireBaseUI>/Resources
  COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Examples/FireBaseUI/Info.plist $<TARGET_FILE_DIR:FireBaseUI>/Info.plist
  COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/Examples/FireBaseUI/$<TARGET_FILE_NAME:FireBaseUI>.manifest $<TARGET_FILE_DIR:FireBaseUI>/$<TARGET_FILE_NAME:FireBaseUI>.manifest)
