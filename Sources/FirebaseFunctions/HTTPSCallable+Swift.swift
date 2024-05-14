// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public class HTTPSCallable {
  let impl: firebase.functions.HttpsCallableReference

  init(_ impl: firebase.functions.HttpsCallableReference) {
    self.impl = impl
  }

  public func call(_ data: Any? = nil, completion: @escaping (HTTPSCallableResult?, Error?) -> Void) {
    callImpl(data: data) { result, error in
      DispatchQueue.main.async {
        completion(result, error)
      }
    }
  }

  public func call(_ data: Any? = nil) async throws -> HTTPSCallableResult {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<HTTPSCallableResult, any Error>) in
      callImpl(data: data) { result, error in
        if let error {
          continuation.resume(throwing: error)
        } else{
          continuation.resume(returning: result ?? .init())
        }
      }
    }
  }

  private func callImpl(data: Any?, completion: @escaping (HTTPSCallableResult?, Error?) -> Void) {
    let variant = try! toVariant(data)
    let future = swift_firebase.swift_cxx_shims.firebase.functions.https_callable_call(impl, variant)
    future.setCompletion({
      let (result, error) = future.resultAndError { FunctionsErrorCode($0) }
      completion(result.map { .init($0) }, error)
    })
  }
}
