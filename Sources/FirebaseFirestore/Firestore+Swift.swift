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
    var result: firebase.InitResult = .init(rawValue: 12)

    var firestore: Firestore?

    var functions: [firebase.ModuleInitializer.InitializerFn?] = [
      { (app, context) in
        print("We're trying to initialize the Firestore...")
        var result: firebase.InitResult = .init(12)

        guard let instance = firebase.firestore.Firestore.GetInstance(app, &result) else {
          fatalError("Invalid Firestore Instance, \(result)")
        }

        print("Initialized the firestore: \(instance), \(result)")

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

    typealias Promise = CheckedContinuation<Void, any Error>
    let myInitializer = try await withCheckedThrowingContinuation { (continuation: Promise) in
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

    print("Re-querying for firestore...")
    guard let initializedFirestore = firebase.firestore.Firestore.GetInstance(app, nil) else {
      fatalError("Invalid Firestore Instance, \(result)")
    }

    print("returning firestore")
    return initializedFirestore
  }

  public func document(_ documentPath: String) -> DocumentReference {
    let document = swift_firebase.swift_cxx_shims.firebase.firestore.firestore_document(self.pointee, std.string(documentPath))
    print("retreived document: \(document) - \(documentPath)")
    return document
  }

  public func collection(_ collectionPath: String) -> CollectionReference {
    swift_firebase.swift_cxx_shims.firebase.firestore.firestore_collection(self.pointee, std.string(collectionPath))
  }

  public func printSettings() {
    let settings = swift_firebase.swift_cxx_shims.firebase.firestore.firestore_settings(self.pointee)
    print("Firestore Settings: \n \(settings)")
  }
}
