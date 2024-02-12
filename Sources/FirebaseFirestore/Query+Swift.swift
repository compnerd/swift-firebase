// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Error)
import FirebaseCore

import CxxShim

public typealias Query = firebase.firestore.Query

extension Query {
  var firestore: Firestore {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_firestore(self)
  }

  func getDocuments(completion: @escaping (QuerySnapshot?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.firestore.query_get(self, .default)
    FutureSupport.runWork({
      future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
    }, completion: { _ in
      if future.error() == 0 {
        completion(future.__resultUnsafe().pointee, nil)
      } else {
        let message = String(cString: future.__error_messageUnsafe()!)
        completion(nil, FirebaseError(code: future.error(), message: message))
      }
      /*
      typealias CompletionType = (QuerySnapshot?, Error?) -> Void
      withUnsafePointer(to: completion) { completion in
        swift_firebase.swift_cxx_shims.firebase.future_with_result_or_error(future, { result, error, pvCompletion in
          let pCompletion = pvCompletion?.assumingMemoryBound(to: CompletionType.self)
          if let result {
            pCompletion.pointee(result, nil)
          } else {
            pCompletion.pointee(nil, FirebaseError(code: error, message: nil))
          }
        })
      }
      */
      /*
      future.withResultOrError { result, error in
        completion(result, error)
      }
      */
    })
  }

  func getDocuments() async throws -> QuerySnapshot {
    try await withCheckedThrowingContinuation { continuation in
      getDocuments() { snapshot, error in
        if let error {
          continuation.resume(throwing: error)
        }
        continuation.resume(returning: snapshot ?? .init())
      }
    }
  }
}
