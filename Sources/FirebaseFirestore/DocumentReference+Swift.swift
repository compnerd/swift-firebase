// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public typealias DocumentReference = firebase.firestore.DocumentReference

extension DocumentReference {
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

  // This variant is provided for compatibility with the ObjC API.
  public func getDocument(source: FirestoreSource = .default, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.firestore.document_get(self, source)
    future.setCompletion({
      let (snapshot, error) = future.resultAndError
      DispatchQueue.main.async {
        completion(snapshot, error)
      }
    })
  }

  public func getDocument(source: FirestoreSource = .default) async throws -> DocumentSnapshot {
    try await withCheckedThrowingContinuation { continuation in
      let future = swift_firebase.swift_cxx_shims.firebase.firestore.document_get(self, source)
      future.setCompletion({
        let (snapshot, error) = future.resultAndError
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: snapshot ?? .init())
        }
      })
    }
  }

  public func addSnapshotListener(_ listener: @escaping (DocumentSnapshot?, Error?) -> Void) -> ListenerRegistration {
    addSnapshotListener(includeMetadataChanges: false, listener: listener)
  }

  public func addSnapshotListener(includeMetadataChanges: Bool, listener: @escaping (DocumentSnapshot?, Error?) -> Void) -> ListenerRegistration {
    typealias ListenerCallback = (DocumentSnapshot?, Error?) -> Void
    let boxed = Unmanaged.passRetained(listener as AnyObject)
    let instance = swift_firebase.swift_cxx_shims.firebase.firestore.document_add_snapshot_listener(
      self, { snapshot, errorCode, errorMessage, pvListener in
        let callback = Unmanaged<AnyObject>.fromOpaque(pvListener!).takeUnretainedValue() as! ListenerCallback

        let error = FirestoreErrorCode(errorCode, errorMessage: errorMessage)
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
      },
      boxed.toOpaque()
    )
    return ListenerRegistration(boxed, instance)
  }

  public func setData(_ data: [String: Any], merge: Bool = false, completion: ((Error?) -> Void)?) {
    setDataImpl(data, merge: merge) { error in
      if let completion {
        DispatchQueue.main.async {
          completion(error)
        }
      }
    }
  }

  private func setDataImpl(_ data: [String: Any], merge: Bool, completion: @escaping (Error?) -> Void) {
    let converted = FirestoreDataConverter.firestoreValue(document: data)
    let options = merge ? firebase.firestore.SetOptions.Merge() : firebase.firestore.SetOptions()
    let future = swift_firebase.swift_cxx_shims.firebase.firestore.document_set_data(self, converted, options)
    future.setCompletion({
      let (_, error) = future.resultAndError
      completion(error)
    })
  }
}

extension DocumentReference {
  public func setData(_ data: [String: Any], merge: Bool = false) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
      setDataImpl(data, merge: merge) { error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume()
        }
      }
    }
  }
}

extension DocumentReference: CustomDebugStringConvertible {
  public var debugDescription: String {
    String(self.ToString())
  }
}
