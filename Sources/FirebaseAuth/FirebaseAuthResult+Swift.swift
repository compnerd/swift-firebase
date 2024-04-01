// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

//public typealias AuthDataResult = UnsafeMutablePointer<firebase.auth.AuthResult>

public final class AuthDataResult {
  let impl: firebase.auth.AuthResult

  init(_ impl: firebase.auth.AuthResult = .init()) {
    self.impl = impl
  }

  public var user: User? {
    guard impl.user.is_valid() else { return nil }
    return .init(impl.user)
  }

  // public var additionalUserInfo: AdditionalUserInfo? {
  //   fatalError("\(#function) not yet implemented")
  // }

  // public var credential: AuthCredential? {
  //   fatalError("\(#function) not yet implemented")
  // }
}
