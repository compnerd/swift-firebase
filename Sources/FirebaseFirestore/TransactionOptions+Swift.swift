// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

public typealias TransactionOptions = firebase.firestore.TransactionOptions

extension TransactionOptions {
  public var maxAttempts: Int {
    get {
      Int(max_attempts())
    }
    set {
      set_max_attempts(Int32(newValue))
    }
  }
}
