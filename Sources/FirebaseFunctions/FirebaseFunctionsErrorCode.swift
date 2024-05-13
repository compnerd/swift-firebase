// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

public struct FirebaseFunctionsErrorCode: Error {
  public let rawValue: Int
  public let localizedDescription: String

  internal init(_ params: (code: Int32, message: String)) {
    self.rawValue = Int(params.code)
    localizedDescription = params.message
  }

  private init(_ error: firebase.functions.Error) {
    self.init(rawValue: Int(error.rawValue))
  }
}

extension FirebaseFunctionsErrorCode: RawRepresentable {
  public typealias RawValue = Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
    localizedDescription = "\(rawValue)"
  }
}

extension FirebaseFunctionsErrorCode {
  init(_ error: firebase.functions.Error, errorMessage: String?) {
    self.init((code: error.rawValue, message: errorMessage ?? "\(error.rawValue)"))
  }

  init?(_ error: firebase.functions.Error?, errorMessage: UnsafePointer<CChar>?) {
    guard let actualError = error, actualError.rawValue != 0 else { return nil }
    var errorMessageString: String?
    if let errorMessage {
      errorMessageString = .init(cString: errorMessage)
    }
    self.init(actualError, errorMessage: errorMessageString)
  }
}

extension FirebaseFunctionsErrorCode {
  public static var none: Self { .init(firebase.functions.kErrorNone) }
  public static var cancelled: Self { .init(firebase.functions.kErrorCancelled) }
  public static var unknown: Self { .init(firebase.functions.kErrorUnknown) }
  public static var invalidArgument: Self { .init(firebase.functions.kErrorInvalidArgument) }
  public static var deadlineExceeded: Self { .init(firebase.functions.kErrorDeadlineExceeded) }
  public static var notFound: Self { .init(firebase.functions.kErrorNotFound) }
  public static var alreadyExists: Self { .init(firebase.functions.kErrorAlreadyExists) }
  public static var permissionDenied: Self { .init(firebase.functions.kErrorPermissionDenied) }
  public static var unauthenticated: Self { .init(firebase.functions.kErrorUnauthenticated) }
  public static var resourceExhausted: Self { .init(firebase.functions.kErrorResourceExhausted) }
  public static var failedPrecondition: Self { .init(firebase.functions.kErrorFailedPrecondition) }
  public static var aborted: Self { .init(firebase.functions.kErrorAborted) }
  public static var outOfRange: Self { .init(firebase.functions.kErrorOutOfRange) }
  public static var unimplemented: Self { .init(firebase.functions.kErrorUnimplemented) }
  public static var `internal`: Self { .init(firebase.functions.kErrorInternal) }
  public static var unavailable: Self { .init(firebase.functions.kErrorUnavailable) }
  public static var dataLoss: Self { .init(firebase.functions.kErrorDataLoss) }
}

extension FirebaseFunctionsErrorCode: Equatable {}

extension FirebaseFunctionsErrorCode {
  // The Obj C API provides this type as well, so provide it here for consistency.
  public typealias Code = FirebaseFunctionsErrorCode

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
