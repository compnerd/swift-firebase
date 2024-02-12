// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Internal)
import FirebaseCore

import CxxShim

public typealias Query = firebase.firestore.Query

/*
extension FutureProtocol {
  func wait(completion: @escaping (Bool) -> Void) {
    FutureSupport.runWork({
      Wait(firebase.FutureBase.kWaitTimeoutInfinite)
    }, completion: completion)
  }
}
*/

extension Query {
  var firestore: Firestore {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_firestore(self)
  }
        /*
        if let error = future.error {
          completion(nil, error)
        } else {
          completion(future.result, nil)
        }
        */

  func getDocuments(completion: @escaping (QuerySnapshot?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.firestore.query_get(self, .default)
    /*
    withUnsafePointer(to: completion) { completion in
      future.CallOnCompletion({ _ in
        // XXX
      }, UnsafeMutableRawPointer(mutating: completion))
    }
    */

    future.setCompletion({
      // XXX
    })

    /*
    future.wait { result, error in
      completion(result, error)
    }
    */

    /*
    future.wait { error in
      if let error {
        completion(nil, error)
      } else {
        completion(future.__resultUnsafe().pointee, nil)
      }
    }
    */

    #if false
    future.wait(completion: { _ in
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
    #endif
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
