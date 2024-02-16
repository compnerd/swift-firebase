// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public typealias WriteBatch = firebase.firestore.WriteBatch

extension WriteBatch {
  public mutating func setData(_ data: [String : Any], forDocument document: DocumentReference) -> WriteBatch {
    setData(data, forDocument: document, merge: false)
  }

  public mutating func setData(_ data: [String : Any], forDocument document: DocumentReference, merge: Bool) -> WriteBatch {
    _ = swift_firebase.swift_cxx_shims.firebase.firestore.write_batch_set(
      self, document, FirestoreDataConverter.firestoreValue(document: data), merge ? .Merge() : .init()
    )
    return self
  }

  /* TODO: implement
  public mutating func setData(_ data: [String : Any], forDocument document: DocumentReference, mergeFields: [Any]) -> WriteBatch {
  }
  */

  public mutating func updateData(_ fields: [String : Any], forDocument document: DocumentReference) -> WriteBatch {
    _ = swift_firebase.swift_cxx_shims.firebase.firestore.write_batch_update(
      self, document, FirestoreDataConverter.firestoreValue(document: fields)
    )
    return self
  }

  public mutating func deleteDocument(_ document: DocumentReference) -> WriteBatch {
    _ = swift_firebase.swift_cxx_shims.firebase.firestore.write_batch_delete(
      self, document
    )
    return self
  }

  public mutating func commit(completion: @escaping ((Error?) -> Void) = { _ in }) {
    let future = swift_firebase.swift_cxx_shims.firebase.firestore.write_batch_commit(self)
    future.setCompletion({
      let (_, error) = future.resultAndError
      DispatchQueue.main.async {
        completion(error)
      }
    })
  }

  public mutating func commit() async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
      let future = swift_firebase.swift_cxx_shims.firebase.firestore.write_batch_commit(self)
      future.setCompletion({
        let (_, error) = future.resultAndError
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume()
        }
      })
    }
  }
}
