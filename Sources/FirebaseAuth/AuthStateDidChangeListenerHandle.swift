// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import CxxShim

public typealias AuthStateDidChangeListenerHandle = AnyObject

internal class _AuthStateDidChangeListenerHandle {
  /// The boxed version of the callback that was passed in from the Swift caller that we will retain in this object.
  private let callback: Unmanaged<AnyObject>

  /// An internal reference to the actual Firebase listener that we must hold onto.
  internal var listener: UnsafeMutablePointer<firebase.auth.AuthStateListener>

  internal init(_ body: @escaping (Auth, User?) -> Void) {
    self.callback = Unmanaged.passRetained(body as AnyObject)
    self.listener = swift_firebase.swift_cxx_shims.firebase.auth.AuthStateListener.Create({ auth, user, callback in
      guard let auth else { return }
      if let callback, let body = Unmanaged<AnyObject>.fromOpaque(callback).takeUnretainedValue() as? ((Auth, User?) -> Void) {
        body(.init(auth), user.pointee.is_valid() ? user.pointee : nil)
      }
    }, UnsafeMutableRawPointer(self.callback.toOpaque()))
  }

  deinit {
    swift_firebase.swift_cxx_shims.firebase.auth.AuthStateListener.Destroy(UnsafeMutableRawPointer(self.listener))
  }
}
