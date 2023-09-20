// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Error)
import FirebaseCore

import CxxShim
import Foundation

public typealias Settings = firebase.firestore.Settings

extension Settings: CustomDebugStringConvertible {
  public var debugDescription: String {
    String(ToString())
  }
}