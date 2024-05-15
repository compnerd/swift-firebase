// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public class StorageReference {
  let impl: firebase.storage.StorageReference

  init(_ impl: firebase.storage.StorageReference) {
    self.impl = impl
  }

  public func child(_ path: String) -> StorageReference {
    .init(impl.Child(path))
  }

  public func downloadURL(completion: @escaping (URL?, Error?) -> Void) {
    downloadURLImpl() { result, error in
      DispatchQueue.main.async {
        completion(result, error)
      }
    }
  }

  public func downloadURL() async throws -> URL {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, any Error>) in
      downloadURLImpl() { result, error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: result!)
        }
      }
    }
  }

  private func downloadURLImpl(completion: @escaping (URL?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.storage.storage_reference_get_download_url(impl)
    future.setCompletion({
      let (result, error) = future.resultAndError { StorageErrorCode($0) }
      completion(result.flatMap { .init(string: String($0)) }, error)
    })
  }

  public func putDataAsync(
    _ uploadData: Data,
    metadata: StorageMetadata? = nil,
    onProgress: ((Progress?) -> Void)? = nil
  ) async throws -> StorageMetadata {
    // TODO(PRENG-63978): Add support for `onProgress` callback.
    assert(onProgress == nil, "Missing support for non-nil onProgress")
    let controller = ControllerRef()
    return try await withTaskCancellationHandler {
      try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StorageMetadata, any Error>) in
        let future = uploadData.withUnsafeBytes { ptr in
          let bytes = ptr.baseAddress!.assumingMemoryBound(to: UInt8.self)
          let numBytes = uploadData.count
          if let metadata {
            return swift_firebase.swift_cxx_shims.firebase.storage.storage_reference_put_bytes(
              self.impl, bytes, numBytes, metadata.impl, &controller.impl
            )
          } else {
            return swift_firebase.swift_cxx_shims.firebase.storage.storage_reference_put_bytes(
              self.impl, bytes, numBytes, &controller.impl
            )
          }
        }
        future.setCompletion({
          let (result, error) = future.resultAndError { StorageErrorCode($0) }
          if let error {
            continuation.resume(throwing: error)
          } else {
            continuation.resume(returning: result.map { .init($0) } ?? .init())
          }
        })
      }
    } onCancel: {
      controller.impl.Cancel()
    }
  }
}

// The underlying `firebase.storage.Controller` type is thread-safe.
private class ControllerRef: @unchecked Sendable {
  var impl: firebase.storage.Controller = .init()
}
