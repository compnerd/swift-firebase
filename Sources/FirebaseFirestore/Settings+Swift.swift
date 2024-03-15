// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public struct FirestoreSettings {
  var impl: firebase.firestore.Settings

  init(_ impl: firebase.firestore.Settings) {
    self.impl = impl
  }

  public init() {
    impl = .init()
  }

  public var debugDescription: String {
    String(impl.ToString())
  }

  public var isPersistenceEnabled: Bool {
    get {
      impl.is_persistence_enabled()
    }
    set {
      impl.set_persistence_enabled(newValue)
    }
  }
}

extension FirestoreSettings: CustomDebugStringConvertible {}
