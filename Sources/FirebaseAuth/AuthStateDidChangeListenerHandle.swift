// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import CxxShim

internal typealias ApplicationAuthStateListenerPointer = UnsafeMutablePointer<firebase.auth.AuthStateListener>

/// A mostly opaque type to manage the lifetime of the escaping closure and auth listener C++ class required
/// from the Auth api's `addStateDidChangeListener`.
///
/// This is also used in the `removeStateDidChangeListener` to deregister the internal listener pointer when
/// the calling code need to unsubscribe from these updates.
public class AuthStateDidChangeListenerHandle {
  /// The boxed version of the callback that was passed in from the Swift caller that we will retain in this object.
  private let callback: Unmanaged<AnyObject>

  /// An internal reference to the actual Firebase listener that we must hold onto.
  internal let listener: ApplicationAuthStateListenerPointer

  /// Initialize a new handle with a boxed closure and a pointer to the Firebase Auth listener.
  /// - Parameters:
  ///   - callback: A boxed Swift closure that will be kept alive for the lifetime of this class.
  ///   - listener: A pointer to a C++ AuthStateListener that must be retained for the lifetime of this class.
  internal init(_ callback: Unmanaged<AnyObject>, _ listener: ApplicationAuthStateListenerPointer) {
    self.callback = callback
    self.listener = listener
  }
}
