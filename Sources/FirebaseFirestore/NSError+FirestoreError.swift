// SPDX-License-Identifier: BSD-3-Clause
import Foundation

extension NSError {
  /// An internal function to convert from a Firestore error to an NSError iff the code is non-zero
  /// - Parameter error: The error returned from Firestore
  /// - Returns: An `NSError` if the underlying error code is non-zero.
  internal static func firestore(_ error: firebase.firestore.Error?) -> NSError? {
    guard let actualError = error, actualError.rawValue != 0 else { return nil }

    return NSError(domain: "firebase.firestore", code: Int(actualError.rawValue))
  }
}
