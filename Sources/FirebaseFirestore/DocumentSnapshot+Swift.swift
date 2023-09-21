// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Error)
import FirebaseCore

import CxxShim
import Foundation

public typealias DocumentSnapshot = firebase.firestore.DocumentSnapshot

extension DocumentSnapshot: CustomDebugStringConvertible {
  public var debugDescription: String {
    String(self.ToString())
  }
}
