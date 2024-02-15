// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public typealias Query = firebase.firestore.Query

extension Query {
  public var firestore: Firestore {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_firestore(self)
  }

  // This variant is provided for compatibility with the ObjC API.
  public func getDocuments(completion: @escaping (QuerySnapshot?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.firestore.query_get(self, .default)
    future.setCompletion({
      let (snapshot, error) = future.resultAndError
      DispatchQueue.main.async {
        completion(snapshot, error)
      }
    })
  }

  public func getDocuments() async throws -> QuerySnapshot {
    try await withCheckedThrowingContinuation { continuation in
      let future = swift_firebase.swift_cxx_shims.firebase.firestore.query_get(self, .default)
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
}
