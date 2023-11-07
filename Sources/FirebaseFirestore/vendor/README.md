# Manually Vendored Files From `firebase-ios-sdk`

This is a manual copy of select files from the Firebase iOS SDK Project, Folder Mapping:

- `FirebaseDataEncoder` [firebase-ios-sdk link](https://github.com/firebase/firebase-ios-sdk/tree/master/FirebaseSharedSwift).
- `Codable` [firebase-ios-sdk link](https://github.com/firebase/firebase-ios-sdk/tree/master/Firestore/Swift/Source/Codable).

We've had to manually copy the files because:

1. SwiftPM on Windows (maybe Linux too?) seems unable to cope with the binary artifacts that the larger Firebase package file describes resulting in an inability to resolve the consuming package file if `firebase-ios-sdk` is included as a dependency.
2. The Firebase JSON decoding is a pretty heavily customized version of the JSON decoder, so rather than rolling our own or seeing if Apple's just works we should rely on the implementation from the Firebase Authors.
3. The contents of these files hasn't changed in about a year so they are relatively stable and the additional overhead of creating a forked repo and package feels like overkill.

We've filed [12062](https://github.com/firebase/firebase-ios-sdk/issues/12062) on the Firebase repo to try to break these files out.