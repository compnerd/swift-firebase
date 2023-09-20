// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Error)
import FirebaseCore

import CxxShim
import Foundation

public typealias Firestore = UnsafeMutablePointer<firebase.firestore.Firestore>

extension Firestore {
  public static func firestore() async throws -> Firestore {
    guard let application = firebase.App.GetInstance() else {
      fatalError("no default application")
    }

    return try await firestore(app: application)
  }

  public static func firestore(app: FirebaseApp) async throws -> Firestore {
    var firestore: Firestore?
    let functions: [firebase.ModuleInitializer.InitializerFn?] = [
      { (app, context) in
        var result: firebase.InitResult = .init(12)

        //TODO: Figure out how to pass this back into `context` so we don't have to
        // requery below.
        guard let _ = firebase.firestore.Firestore.GetInstance(app, &result) else {
          fatalError("Invalid Firestore Instance")
        }

        return result
      }
    ]
    var initializer = firebase.ModuleInitializer()
    let future = initializer.Initialize(
      app,
      &firestore,
      functions,
      functions.count
    )

    //TODO: Is this really needed every time we grab our instance? Maybe there's some kind
    // of initialized value we should be checking?
    typealias Promise = CheckedContinuation<Void, any Error>
    _ = try await withCheckedThrowingContinuation { (continuation: Promise) in
      withUnsafePointer(to: continuation) { continuation in
        future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
          let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
          if future.pointee.error() == 0 {
            pContinuation.pointee.resume(returning: ())
          } else {
            let code = future.pointee.error()
            let message = String(cString: future.pointee.__error_messageUnsafe()!)
            pContinuation.pointee.resume(throwing: FirebaseError(code: code, message: message))
          }
        }, UnsafeMutableRawPointer(mutating: continuation))
        future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
      }
    }

    guard let initializedFirestore = firebase.firestore.Firestore.GetInstance(app, nil) else {
      fatalError("Invalid Firestore Instance")
    }

    return initializedFirestore
  }

  public func document(_ documentPath: String) -> DocumentReference {
    swift_firebase.swift_cxx_shims.firebase.firestore.firestore_document(self, std.string(documentPath))
  }

  public func collection(_ collectionPath: String) -> CollectionReference {
    swift_firebase.swift_cxx_shims.firebase.firestore.firestore_collection(self, std.string(collectionPath))
  }
}
