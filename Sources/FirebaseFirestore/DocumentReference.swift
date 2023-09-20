@_exported
import firebase
@_spi(Error)
import FirebaseCore

import CxxShim
import Foundation

public typealias DocumentReference = firebase.firestore.DocumentReference
public typealias DocumentSnapshot = firebase.firestore.DocumentSnapshot

extension DocumentReference {
  public var firestore: Firestore {
    return swift_firebase.swift_cxx_shims.firebase.firestore.document_firestore(self)!
  }

  public var path: String {
    return String(swift_firebase.swift_cxx_shims.firebase.firestore.document_path(self))
  }

  public func get() async throws -> DocumentSnapshot {
    typealias Promise = CheckedContinuation<UnsafeMutablePointer<firebase.firestore.DocumentSnapshot>, any Error>
    let snapshot = try await withCheckedThrowingContinuation { (continuation: Promise) in
      let future = swift_firebase.swift_cxx_shims.firebase.firestore.document_get(self, .default)
      withUnsafePointer(to: continuation) { continuation in
        future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
          let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
          if future.pointee.error() == 0 {
            pContinuation.pointee.resume(returning: .init(mutating: future.pointee.__resultUnsafe()))
          } else {
            let code = future.pointee.error()
            let message = String(cString: future.pointee.__error_messageUnsafe()!)
            pContinuation.pointee.resume(throwing: FirebaseError(code: code, message: message))
          }
        }, UnsafeMutableRawPointer(mutating: continuation))
      }
      future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
    }

    return snapshot.pointee
  }
}

extension DocumentReference: CustomDebugStringConvertible {
  public var debugDescription: String {
    String(self.ToString())
  }
}
