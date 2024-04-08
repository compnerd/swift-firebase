// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

public struct FirestoreErrorCode: Error {
  public let rawValue: Int
  public let localizedDescription: String

  internal init(_ params: (code: Int32, message: String)) {
    self.rawValue = Int(params.code)
    localizedDescription = params.message
  }

  private init(_ error: firebase.firestore.Error) {
    self.init(rawValue: Int(error.rawValue))
  }
}

extension FirestoreErrorCode: RawRepresentable {
  public typealias RawValue = Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
    localizedDescription = "\(rawValue)"
  }
}

extension FirestoreErrorCode {
  init(_ error: firebase.firestore.Error, errorMessage: String?) {
    self.init((code: error.rawValue, message: errorMessage ?? "\(error.rawValue)"))
  }

  init?(_ error: firebase.firestore.Error?, errorMessage: UnsafePointer<CChar>?) {
    guard let actualError = error, actualError.rawValue != 0 else { return nil }
    var errorMessageString: String?
    if let errorMessage {
      errorMessageString = .init(cString: errorMessage)
    }
    self.init(actualError, errorMessage: errorMessageString)
  }
}

extension FirestoreErrorCode {
  public static var ok: Self { .init(firebase.firestore.kErrorOk) }
  public static var none: Self { .init(firebase.firestore.kErrorNone) }
  public static var cancelled: Self { .init(firebase.firestore.kErrorCancelled) }
  public static var unknown: Self { .init(firebase.firestore.kErrorUnknown) }
  public static var invalidArgument: Self { .init(firebase.firestore.kErrorInvalidArgument) }
  public static var deadlineExceeded: Self { .init(firebase.firestore.kErrorDeadlineExceeded) }
  public static var notFound: Self { .init(firebase.firestore.kErrorNotFound) }
  public static var alreadyExists: Self { .init(firebase.firestore.kErrorAlreadyExists) }
  public static var permissionDenied: Self { .init(firebase.firestore.kErrorPermissionDenied) }
  public static var resourceExhausted: Self { .init(firebase.firestore.kErrorResourceExhausted) }
  public static var failedPrecondition: Self { .init(firebase.firestore.kErrorFailedPrecondition) }
  public static var aborted: Self { .init(firebase.firestore.kErrorAborted) }
  public static var outOfRange: Self { .init(firebase.firestore.kErrorOutOfRange) }
  public static var unimplemented: Self { .init(firebase.firestore.kErrorUnimplemented) }
  public static var `internal`: Self { .init(firebase.firestore.kErrorInternal) }
  public static var unavailable: Self { .init(firebase.firestore.kErrorUnavailable) }
  public static var dataLoss: Self { .init(firebase.firestore.kErrorDataLoss) }
  public static var unauthenticated: Self { .init(firebase.firestore.kErrorUnauthenticated) }
}

extension FirestoreErrorCode: Equatable {}

extension FirestoreErrorCode {
  // The Obj C API provides this type as well, so provide it here for consistency.
  public typealias Code = FirestoreErrorCode

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
