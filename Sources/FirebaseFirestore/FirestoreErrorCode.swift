// SPDX-License-Identifier: BSD-3-Clause

public struct FirestoreErrorCode: Error {
  public typealias Code = firebase.firestore.Error

  public let code: Code
  public let localizedDescription: String

  public init(_ error: firebase.firestore.Error, errorMessage: String?) {
    code = error
    localizedDescription = errorMessage ?? "\(code.rawValue)"
  }

  public init?(_ error: firebase.firestore.Error?, errorMessage: UnsafePointer<CChar>? = nil) {
    guard let actualError = error, actualError.rawValue != 0 else { return nil }
    var errorMessageString: String?
    if let errorMessage {
      errorMessageString = .init(cString: errorMessage)
    }
    self.init(actualError, errorMessage: errorMessageString)
  }
}

extension FirestoreErrorCode: Equatable {}

// Unfortunately `Error` is not defined as a `enum class` so we need to add
// these wrappers.
extension FirestoreErrorCode.Code {
  public static var ok: Self { firebase.firestore.kErrorOk }
  public static var none: Self { firebase.firestore.kErrorNone }
  public static var cancelled: Self { firebase.firestore.kErrorCancelled }
  public static var unknown: Self { firebase.firestore.kErrorUnknown }
  public static var invalidArgument: Self { firebase.firestore.kErrorInvalidArgument }
  public static var deadlineExceeded: Self { firebase.firestore.kErrorDeadlineExceeded }
  public static var notFound: Self { firebase.firestore.kErrorNotFound }
  public static var alreadyExists: Self { firebase.firestore.kErrorAlreadyExists }
  public static var permissionDenied: Self { firebase.firestore.kErrorPermissionDenied }
  public static var resourceExhausted: Self { firebase.firestore.kErrorResourceExhausted }
  public static var failedPrecondition: Self { firebase.firestore.kErrorFailedPrecondition }
  public static var aborted: Self { firebase.firestore.kErrorAborted }
  public static var outOfRange: Self { firebase.firestore.kErrorOutOfRange }
  public static var unimplemented: Self { firebase.firestore.kErrorUnimplemented }
  public static var `internal`: Self { firebase.firestore.kErrorInternal }
  public static var unavailable: Self { firebase.firestore.kErrorUnavailable }
  public static var dataLoss: Self { firebase.firestore.kErrorDataLoss }
  public static var unauthenticated: Self { firebase.firestore.kErrorUnauthenticated }
}
