# SwiftFirebase

Swift bindings for [firebase-cpp-sdk](https://github.com/firebase/firebase-cpp-sdk), loosely modelled after the iOS APIs.  It serves as both exploration of the C++ Interop as well as a means of using Firebase on Windows from Swift.

### Requirements

The Swift interface to Firebase is built upon the [Firebase C++ SDK](https://github.com/firebase/firebase-cpp-sdk).  As a result, the package requires that the C++ SDK is available and distributed to the clients.  The package expects that the firebase SDK is present in the root of the source tree under `third_party/firebase-development/usr`.

As of 2023-08-10, the Firebase SDK requires some changes to support the Swift/C++ interop.  The changes for this are available [here](patches/0001-Add-a-couple-of-workarounds-for-Swift-on-Windows.patch).  This has sent upstream as [firebase/firebase-cpp-sdk#1414](https://github.com/firebase/firebase-cpp-sdk/pull/1414).  You can currently use a prebuilt version of the C++ SDK with this patch from [thebrowsercompany/firebase-cpp-sdk](https://github.com/thebrowsercompany/firebase-cpp-sdk) release [20230807.0](https://github.com/thebrowsercompany/firebase-cpp-sdk/releases/tag/20230807.0).

The `google-services.json` file must be updated with the proper values in place of the placeholder values.

### Building

Assuming a build of firebase is available in the top level under `third_party/firebase-development/usr`, the package should build as a standard SPM package using:
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
