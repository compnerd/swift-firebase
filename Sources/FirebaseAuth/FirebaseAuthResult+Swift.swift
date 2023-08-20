// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

public typealias AuthDataResult = UnsafeMutablePointer<firebase.auth.AuthResult>

extension AuthDataResult {
  public var user: User? {
    let user = self.pointee.user
    guard user.is_valid() else { return nil }
    return user
  }

  // public var additionalUserInfo: AdditionalUserInfo? {
  //   fatalError("\(#function) not yet implemented")
  // }

  // public var credential: AuthCredential? {
  //   fatalError("\(#function) not yet implemented")
  // }
}
