# SwiftFirebase

Swift bindings for
[firebase-cpp-sdk](https://github.com/firebase/firebase-cpp-sdk), loosely
modelled after the iOS APIs.  It serves as both exploration of the C++ Interop
as well as a means of using Firebase on Windows from Swift.

### Requirements

Requires that the Firebase C++ SDK is installed.  You can use the latest binary
release or build it from source.

The `google-services.json`` file must be updated with the proper values.
Additionally, the authentication information which is currently hardcoded into
the demo application must be updated.

### Building

The Swift support requires a couple of workarounds.  The changes are available
in the patches directory.  They should be applied to
[firebase-cpp-sdk](https://github.com/firebase/firebase-cpp-sdk) prior to
building. For convenience, a build of firebase is expected in the top level
under `third_party/firebase-development/usr`.
