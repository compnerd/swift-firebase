// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

public typealias FieldValue = firebase.firestore.FieldValue

extension FieldValue {
  public static func serverTimestamp() -> Self {
    ServerTimestamp()
  }
}

extension FieldValue: Equatable {}
