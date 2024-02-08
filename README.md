# SwiftFirebase

Swift bindings for [firebase-cpp-sdk](https://github.com/firebase/firebase-cpp-sdk), loosely modelled after the iOS APIs.  It serves as both exploration of the C++ Interop as well as a means of using Firebase on Windows from Swift.

## Requirements

The Swift interface to Firebase is built upon the [Firebase C++ SDK](https://github.com/firebase/firebase-cpp-sdk).  As a result, the package requires that the C++ SDK is available and distributed to the clients.  The package expects that the firebase SDK is present in the root of the source tree under `third_party/firebase-development/usr`.

As of 2023-08-10, the Firebase SDK requires some changes to support the Swift/C++ interop.  The changes for this are available [here](patches/0001-Add-a-couple-of-workarounds-for-Swift-on-Windows.patch).  This has sent upstream as [firebase/firebase-cpp-sdk#1414](https://github.com/firebase/firebase-cpp-sdk/pull/1414).

## Setup

### Prerequisites

0. Make sure you have a Swift toolchain that supports C++ interop.
1. Download the lastest build of the Firebase C++ SDK from https://github.com/thebrowsercompany/firebase-cpp-sdk/tags, click on the tag and then download the pre-build artifacts. These will be called `firebase-windows-amd64.zip` or `firebase-windows-arm64.zip` depending on which architecture you'd like to build for.
3. Run `md third_party\firebase-development` to create the directory where we will extract the Firebase C++ SDK release that was just downloaded
4. Extract the Firebase C++ SDK release into the `third_party\firebase-development` directory that was just created.
5. Modify the `Examples\FireBaseUI\Resources\google-services.json` file to include the correct values from Firebase.

> [!TIP]
> It can be useful to mark the `google-services.json` file as assumed unchanged so you don't accidentially check it in with real credentials. To do that, you can run the following: `git update-index --assume-unchanged .\Examples\FireBaseUI\Resources\google-services.json`

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
