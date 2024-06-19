// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

public struct StorageErrorCode: Error {
  public let rawValue: Int
  public let localizedDescription: String

  internal init(_ params: (code: Int32, message: String)) {
    self.rawValue = Int(params.code)
    localizedDescription = params.message
  }

  private init(_ error: firebase.storage.Error) {
    self.init(rawValue: Int(error.rawValue))
  }
}

extension StorageErrorCode: RawRepresentable {
  public typealias RawValue = Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
    localizedDescription = "\(rawValue)"
  }
}

extension StorageErrorCode {
  init(_ error: firebase.storage.Error, errorMessage: String?) {
    self.init((code: numericCast(error.rawValue), message: errorMessage ?? "\(error.rawValue)"))
  }

  init?(_ error: firebase.storage.Error?, errorMessage: UnsafePointer<CChar>?) {
    guard let actualError = error, actualError.rawValue != 0 else { return nil }
    var errorMessageString: String?
    if let errorMessage {
      errorMessageString = .init(cString: errorMessage)
    }
    self.init(actualError, errorMessage: errorMessageString)
  }
}

extension StorageErrorCode {
  public static var none: Self { .init(firebase.storage.kErrorNone) }
  public static var unknown: Self { .init(firebase.storage.kErrorUnknown) }
  public static var objectNotFound: Self { .init(firebase.storage.kErrorObjectNotFound) }
  public static var bucketNotFound: Self { .init(firebase.storage.kErrorBucketNotFound) }
  public static var projectNotFound: Self { .init(firebase.storage.kErrorProjectNotFound) }
  public static var quotaExceeded: Self { .init(firebase.storage.kErrorQuotaExceeded) }
  public static var unauthenticated: Self { .init(firebase.storage.kErrorUnauthenticated) }
  public static var unauthorized: Self { .init(firebase.storage.kErrorUnauthorized) }
  public static var retryLimitExceeded: Self { .init(firebase.storage.kErrorRetryLimitExceeded) }
  public static var nonMatchingChecksum: Self { .init(firebase.storage.kErrorNonMatchingChecksum) }
  public static var downloadSizeExceeded: Self { .init(firebase.storage.kErrorDownloadSizeExceeded) }
  public static var cancelled: Self { .init(firebase.storage.kErrorCancelled) }
}

extension StorageErrorCode: Equatable {}

extension StorageErrorCode {
  // The Obj C API provides this type as well, so provide it here for consistency.
  public typealias Code = StorageErrorCode

  // This allows us to re-expose self as a code similarly
  // to what the Firebase SDK does when it creates the
  // underlying NSErrors on iOS/macOS.
  public var code: Code {
    return self
  }

  public init(_ code: Code) {
    self.init(rawValue: code.rawValue)
  }
}
