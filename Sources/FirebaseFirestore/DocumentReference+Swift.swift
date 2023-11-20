// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Error)
import FirebaseCore

import CxxShim
import Foundation

public typealias DocumentReference = firebase.firestore.DocumentReference
public typealias SnapshotListenerCallback = (DocumentSnapshot?, NSError?) -> Void


extension DocumentReference {
  public var documentID: String {
    String(swift_firebase.swift_cxx_shims.firebase.firestore.document_id(self))
  }

  public var firestore: Firestore {
    swift_firebase.swift_cxx_shims.firebase.firestore.document_firestore(self)!
  }

  public var path: String {
    String(swift_firebase.swift_cxx_shims.firebase.firestore.document_path(self))
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

  public func addSnapshotListener(_ listener: @escaping SnapshotListenerCallback) -> ListenerRegistration {
    addSnapshotListener(includeMetadataChanges: false, listener: listener)
  }

  public func addSnapshotListener(includeMetadataChanges: Bool, listener: @escaping SnapshotListenerCallback) -> ListenerRegistration {
    let boxed = Unmanaged.passRetained(listener as AnyObject)
    let instance = swift_firebase.swift_cxx_shims.firebase.firestore.document_add_snapshot_listener(self, { snapshot, errorCode, errorMessage, pvListener in
        if let pvListener = pvListener, let callback = Unmanaged<AnyObject>.fromOpaque(pvListener).takeUnretainedValue() as? SnapshotListenerCallback {
          let error = NSError.firestore(errorCode)
          // We only return a snapshot if the error code isn't 0 (aka the 'ok' error code)
          let returned = error == nil ? snapshot?.pointee : nil
          callback(returned, error)
        }
      }, UnsafeMutableRawPointer(boxed.toOpaque()))

    return ListenerRegistration(boxed, instance)
  }
}

extension DocumentReference: CustomDebugStringConvertible {
  public var debugDescription: String {
    String(self.ToString())
  }
}
