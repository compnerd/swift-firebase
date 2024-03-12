// SPDX-License-Identifier: BSD-3-Clause

import CxxStdlib
import Foundation

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim

public typealias User = firebase.auth.User
public typealias AuthResult = firebase.auth.AuthResult

public protocol UserInfo {
  var providerID: String { get }
  var uid: String { get }
  var displayName: String? { get }
  var photoURL: URL? { get }
  var email: String? { get }
  var phoneNumber: String? { get }
}

// TODO(WPP-1581): Improve the API to match the ObjC one better.
extension User {
  public var isAnonymous: Bool {
    self.is_anonymous()
  }

  public var isEmailVerified: Bool {
    self.is_email_verified()
  }

  public var refreshToken: String? {
    fatalError("\(#function) not yet implemented")
  }

  // public var providerData: [UserInfo] {
  //   fatalError("\(#function) not yet implemented")
  // }

  // public var metadata: UserMetadata {
  //   fatalError("\(#function) not yet implemented")
  // }

  public var tenantID: String? {
    fatalError("\(#function) not yet implemented")
  }

  // public var multiFactor: MultiFactor {
  //   fatalError("\(#function) not yet implemented")
  // }

  public func updateEmail(to email: String) async throws {
    fatalError("\(#function) not yet implemented")
  }

  public func updatePassword(to password: String) async throws {
    fatalError("\(#function) not yet implemented")
  }

  // public func updatePhoneNumber(_ credential: PhoneAuthCredential) async throws {
  //   fatalError("\(#function) not yet implemented")
  // }

  // public func createProfileChangeRequest() -> UserProfileChangeRequest {
  //   fatalError("\(#function) not yet implemented")
  // }

  public mutating func reload(completion: ((Error?) -> Void)?) {
    reloadImpl() { error in
      if let completion {
        DispatchQueue.main.async {
          completion(error)
        }
      }
    }
  }

  public mutating func reload() async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
      reloadImpl() { error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume()
        }
      }
    }
  }

  private mutating func reloadImpl(completion: @escaping (Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.auth.user_reload(self)
    future.setCompletion({
      let (_, error) = future.resultAndError
      completion(error)
    })
  }

  public mutating func reauthenticate(with credential: Credential, completion: ((AuthResult?, Error?) -> Void)?) {
    reauthenticateImpl(with: credential) { result, error in
      if let completion {
        DispatchQueue.main.async {
          completion(result, error)
        }
      }
    }
  }

  public mutating func reauthenticate(with credential: Credential) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
      reauthenticateImpl(with: credential) { result, error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume()
        }
      }
    }
  }

  public mutating func reauthenticateImpl(with credential: Credential, completion: @escaping (AuthResult?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.auth.user_reauthenticate_and_retrieve_data(self, credential)
    future.setCompletion({
      let (result, error) = future.resultAndError
      completion(result, error)
    })
  }

  // -reauthenticateWithProvider:UIDelegate:completion:

  public mutating func getIDTokenResult() async throws -> AuthTokenResult {
    return try await getIDTokenResult(forcingRefresh: false)
  }

  public mutating func getIDTokenResult(forcingRefresh forceRefresh: Bool) async throws
      -> AuthTokenResult {
    return try await AuthTokenResult(idTokenForcingRefresh(forceRefresh))
  }

  public mutating func getIDToken() async throws -> String {
    return try await idTokenForcingRefresh(false)
  }

  public mutating func idTokenForcingRefresh(_ forceRefresh: Bool, completion: ((String?, Error?) -> Void)?) {
    idTokenForcingRefreshImpl(forceRefresh) { result, error in
      if let completion {
        DispatchQueue.main.async {
          completion(result, error)
        }
      }
    }
  }

  public mutating func idTokenForcingRefresh(_ forceRefresh: Bool) async throws
      -> String {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, any Error>) in
      idTokenForcingRefreshImpl(forceRefresh) { result, error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: result ?? .init())
        }
      }
    }
  }

  private mutating func idTokenForcingRefreshImpl(_ forceRefresh: Bool, completion: @escaping (String?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.auth.user_get_token(self, forceRefresh)
    future.setCompletion({
      let (result, error) = future.resultAndError
      let stringResult: String?
      if let result {
        stringResult = String(result)
      } else {
        stringResult = nil
      }
      completion(stringResult, error)
    })
  }

  // public func link(with credential: AuthCredential) async throws
  //     -> AuthDataResult {
  //   fatalError("\(#function) not yet implemented")
  // }

  // -linkWithProvider:UIDelegate:completion

  public func unlink(from provider: String) async throws -> User {
    fatalError("\(#function) not yet implemented")
  }

  public mutating func sendEmailVerification(completion: ((Error?) -> Void)?) {
    sendEmailVerificationImpl() { error in
      if let completion {
        DispatchQueue.main.async {
          completion(error)
        }
      }
    }
  }

  public mutating func sendEmailVerification() async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
      sendEmailVerificationImpl() { error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume()
        }
      }
    }
  }

  public mutating func sendEmailVerificationImpl(completion: @escaping (Error?) -> Void) {
    //let future = self.SendEmailVerification()
    let future = swift_firebase.swift_cxx_shims.firebase.auth.user_send_email_verification(self)
    future.setCompletion({
      let (_, error) = future.resultAndError
      completion(error)
    })
  }

  // public func sendEmailVerification(with actionCodeSettings: ActionCodeSettings) async throws {
  //   fatalError("\(#function) not yet implemented")
  // }

  public func delete() async throws {
    fatalError("\(#function) not yet implemented")
  }

  public func sendEmailVerification(beforeUpdatingEmail email: String) async throws {
    fatalError("\(#function) not yet implemented")
  }

  // public func sendEmailVerification(beforeUpdatingEmail email: String,
  //                                   actionCodeSettings: ActionCodeSettings) async throws {
  //   fatalError("\(#function) not yet implemented")
  // }
}

extension User: UserInfo {
  public var providerID: String {
    String(swift_firebase.swift_cxx_shims.firebase.auth.user_provider_id(self))
  }

  public var uid: String {
    String(swift_firebase.swift_cxx_shims.firebase.auth.user_uid(self))
  }

  public var displayName: String? {
    let name = String(swift_firebase.swift_cxx_shims.firebase.auth.user_display_name(self))
    return name.isEmpty ? nil : name
  }

  public var photoURL: URL? {
    let url = String(swift_firebase.swift_cxx_shims.firebase.auth.user_photo_url(self))
    return url.isEmpty ? nil : URL(string: url)
  }

  public var email: String? {
    let email = String(swift_firebase.swift_cxx_shims.firebase.auth.user_email(self))
    return email.isEmpty ? nil : email
  }

  public var phoneNumber: String? {
    let number = String(swift_firebase.swift_cxx_shims.firebase.auth.user_phone_number(self))
    return number.isEmpty ? nil : number
  }
}
