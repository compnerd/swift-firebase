// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Internal)
import FirebaseCore

import CxxShim
import Foundation

public struct ListenerRegistration {
  private let listener: Unmanaged<AnyObject>
  private let registration: firebase.firestore.ListenerRegistration

  init(_ listener: Unmanaged<AnyObject>, _ registration: firebase.firestore.ListenerRegistration) {
    self.listener = listener
    self.registration = registration
  }

  public func remove() {
    swift_firebase.swift_cxx_shims.firebase.firestore.listener_registration_remove(registration)
    _ = listener.takeRetainedValue()
  }
}
