// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import Foundation

@_spi(FirebaseInternal)
public typealias FutureCompletionType =
  swift_firebase.swift_cxx_shims.firebase.FutureCompletionType

// This protocol enables extracting common code for Future handling. Because
// C++ interop is limited for templated class types, we need to invent a
// protocol to reflect the features of a Future<R> that should be generically
// available. This works by having a C++ annotation (see swift_cxx_shims'
// Future<R>) that specifies this protocol conformance.
@_spi(FirebaseInternal)
public protocol FutureProtocol {
  associatedtype ResultType
  func error() -> Int32
  func __error_messageUnsafe() -> UnsafePointer<CChar>?
  func __resultUnsafe() -> UnsafePointer<ResultType>?
  func OnCompletion(
    _ completion: FutureCompletionType,
    _ user_data: UnsafeMutableRawPointer?
  )
}

@_spi(FirebaseInternal)
public extension FutureProtocol {
  // Callsites retain their own reference to the Future<R>, but they still need
  // a way to know when the Future completes. This provides that mechanism.
  // While the underlying Firebase `OnCompletion` method can provide a reference
  // back to the Future, we don't need to expose that here.
  func setCompletion(_ completion: @escaping () -> Void) {
    OnCompletion({ ptr in
      Unmanaged<CompletionReference>.fromOpaque(ptr!).takeRetainedValue().completion()
    }, Unmanaged.passRetained(CompletionReference(completion)).toOpaque())
  }

  var result: ResultType? {
    __resultUnsafe().pointee
  }

  var errorMessage: String? {
    guard let errorMessageUnsafe = __error_messageUnsafe() else { return nil }
    return String(cString: errorMessageUnsafe)
  }

  var resultAndError: (ResultType?, Error?) {
    let error = error()
    guard error == 0 else {
      return (nil, FirebaseError(code: error, message: errorMessage!))
    }
    return (result, nil)
  }
}

// The Unmanaged type only works with classes, so we need a wrapper for the
// completion callback.
private class CompletionReference {
  let completion: () -> Void
  init(_ completion: @escaping () -> Void) {
    self.completion = completion
  }
}
