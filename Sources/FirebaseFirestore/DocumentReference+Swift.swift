// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Internal)
import FirebaseCore

import CxxShim
import Foundation

public typealias DocumentReference = firebase.firestore.DocumentReference
public typealias SnapshotListenerCallback = (DocumentSnapshot?, NSError?) -> Void

extension DocumentReference {
  // Use a serial dispatch queue to write mutations from the block-based API.
  // Passing these futures into the queue as an item should retain them long enough
  // to do their job, but not block.
  private static let mutationQueue = DispatchQueue(label: "firebase.firestore.document.mutations")

  public var documentID: String {
    String(swift_firebase.swift_cxx_shims.firebase.firestore.document_id(self))
  }

  public var firestore: Firestore {
    swift_firebase.swift_cxx_shims.firebase.firestore.document_firestore(self)!
  }

  public func collection(_ path: String) -> CollectionReference {
    swift_firebase.swift_cxx_shims.firebase.firestore.document_collection(self, std.string(path))
  }

  public var path: String {
    String(swift_firebase.swift_cxx_shims.firebase.firestore.document_path(self))
  }

  public func get() async throws -> DocumentSnapshot? {
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

    guard snapshot.pointee.exists else { return nil }
    return snapshot.pointee.is_valid() ? snapshot.pointee : nil
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

          // Make sure we dispatch our callback back into the main thread to keep consistent
          // with the reference API which will call back on the 'user_executor' which typically
          // ends up being the main queue.
          // Relevant code:
          // - https://github.com/firebase/firebase-ios-sdk/blob/main/Firestore/Source/API/FIRFirestore.mm#L210-L218
          // - https://github.com/firebase/firebase-ios-sdk/blob/main/Firestore/core/src/api/document_reference.cc#L236-L237
          DispatchQueue.main.async {
            callback(returned, error)
          }
        }
      }, UnsafeMutableRawPointer(boxed.toOpaque()))

    return ListenerRegistration(boxed, instance)
  }

  public func setData(_ data: [String: Any], merge: Bool = false, completion: ((NSError?) -> Void)?) {
    let boxed = Unmanaged.passRetained(completion as AnyObject)
    let converted = FirestoreDataConverter.firestoreValue(document: data)
    let options = merge ? firebase.firestore.SetOptions.Merge() : firebase.firestore.SetOptions()

    Self.mutationQueue.async {
      let future = swift_firebase.swift_cxx_shims.firebase.firestore.document_set_data(self, converted, options)

      future.OnCompletion_SwiftWorkaround({ future, pvCallback in
        guard let pCallback = pvCallback, let callback = Unmanaged<AnyObject>.fromOpaque(pCallback).takeUnretainedValue() as? ((NSError?) -> Void)? else {
          return
        }
        if let code = future?.pointee.error(), code != 0 {
          callback?(NSError(domain: "firebase.firestore.document", code: Int(code)))
        } else {
          callback?(nil)
        }
      }, UnsafeMutableRawPointer(boxed.toOpaque()))

      future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
    }
  }
}

extension DocumentReference {
  public func setData(_ data: [String: Any], merge: Bool = false) async throws {
    let converted = FirestoreDataConverter.firestoreValue(document: data)
    let options = merge ? firebase.firestore.SetOptions.Merge() : firebase.firestore.SetOptions()

    typealias Promise = CheckedContinuation<Void, any Error>
    try await withCheckedThrowingContinuation { (continuation: Promise) in
      let future = swift_firebase.swift_cxx_shims.firebase.firestore.document_set_data(self, converted, options)
      withUnsafePointer(to: continuation) { continuation in
        future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
          let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
          if future.pointee.error() == 0 {
            pContinuation.pointee.resume()
          } else {
            let code = future.pointee.error()
            let message = String(cString: future.pointee.__error_messageUnsafe()!)
            pContinuation.pointee.resume(throwing: FirebaseError(code: code, message: message))
          }
        }, UnsafeMutableRawPointer(mutating: continuation))

        future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
      }
    }
  }
}

extension DocumentReference: CustomDebugStringConvertible {
  public var debugDescription: String {
    String(self.ToString())
  }
}
