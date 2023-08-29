# SwiftFirebase

Swift bindings for [firebase-cpp-sdk](https://github.com/firebase/firebase-cpp-sdk), loosely modelled after the iOS APIs.  It serves as both exploration of the C++ Interop as well as a means of using Firebase on Windows from Swift.

## Requirements

The Swift interface to Firebase is built upon the [Firebase C++ SDK](https://github.com/firebase/firebase-cpp-sdk).  As a result, the package requires that the C++ SDK is available and distributed to the clients.  The package expects that the firebase SDK is present in the root of the source tree under `third_party/firebase-development/usr`.

As of 2023-08-10, the Firebase SDK requires some changes to support the Swift/C++ interop.  The changes for this are available [here](patches/0001-Add-a-couple-of-workarounds-for-Swift-on-Windows.patch).  This has sent upstream as [firebase/firebase-cpp-sdk#1414](https://github.com/firebase/firebase-cpp-sdk/pull/1414).

## Setup

### Prerequisites

0. Make sure you have the right Swift toolchain installed, currently this repo requires at least https://download.swift.org/development/windows10/swift-DEVELOPMENT-SNAPSHOT-2023-08-12-a/swift-DEVELOPMENT-SNAPSHOT-2023-08-12-a-windows10.exe to build.
1. Download the lastest build of the Firebase C++ SDK from https://github.com/thebrowsercompany/firebase-cpp-sdk/tags
2. Run `md third_party\firebase-development` to create the directory where we will extract the Firebase C++ SDK release that was just downloaded
3. Extract the Firebase C++ SDK release into the `third_party\firebase-development` directory that was just created.
4. Modify the `Examples\FireBaseUI\Resources\google-services.json` file to include the correct values from Firebase.

### Building

#### SwiftPM

Assuming a build of firebase is available in the top level under `third_party\firebase-development\usr`, the package should build as a standard SPM package using:
```powershell
swift build
```

A demo application is included as a sample and requires some additional setup due to the auxiliary files needing to be deployed.
```powershell
swift build --product FireBaseUI
copy Examples\FireBaseUI\Info.plist .build\debug\
copy Examples\FireBaseUI\FireBaseUI.exe.manifest .build\debug\
swift run
```

#### CMake

Assuming a build of firebase is available in the top level under `third_party\firebase-development\usr`, the package should build as a standard CMake package using:
```powershell
cmake -B out -G Ninja -S .
```

You should be able to run the demo application subsequently by just launching it as:
```powershell
.\out\bin\FireBaseUI.exe
```
