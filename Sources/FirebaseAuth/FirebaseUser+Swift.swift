// SPDX-License-Identifier: BSD-3-Clause

import CxxStdlib
import Foundation

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

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

  public mutating func reload() async throws {
    typealias Promise = CheckedContinuation<Void, any Error>
    try await withCheckedThrowingContinuation { (continuation: Promise) in
      let future = self.Reload()
      withUnsafePointer(to: continuation) { continuation in
        future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
          let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
          if future.pointee.error() == 0 {
            pContinuation.pointee.resume()
          } else {
            let code = future.pointee.error()
            let message = String(cString: future.pointee.__error_messageUnsafe()!)
            pContinuation.pointee.resume(throwing: FirebaseError(code: code, message: message))
          }
        }, UnsafeMutableRawPointer(mutating: continuation))
      }
      future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
    }
  }

  public mutating func reauthenticate(with credential: Credential) async throws
      -> AuthResult {
      typealias Promise = CheckedContinuation<firebase.auth.AuthResult, any Error>
      return try await withCheckedThrowingContinuation { (continuation: Promise) in
        let future = self.ReauthenticateAndRetrieveData(credential)
        withUnsafePointer(to: continuation) { continuation in
          future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
            let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
            if future.pointee.error() == 0 {
              pContinuation.pointee.resume(returning: future.pointee.__resultUnsafe().pointee)
            } else {
              let code = future.pointee.error()
              let message = String(cString: future.pointee.__error_messageUnsafe()!)
              pContinuation.pointee.resume(throwing: FirebaseError(code: code, message: message))
            }
          }, UnsafeMutableRawPointer(mutating: continuation))
        }
        future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
      }
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

  public mutating func idTokenForcingRefresh(_ forceRefresh: Bool) async throws
      -> String {
    typealias Promise = CheckedContinuation<String, any Error>
    return try await withCheckedThrowingContinuation { (continuation: Promise) in
      let future = self.GetToken(forceRefresh)
      withUnsafePointer(to: continuation) { continuation in
        future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
          let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
          if future.pointee.error() == 0 {
            pContinuation.pointee.resume(returning: String(future.pointee.__resultUnsafe().pointee))
          } else {
            let code = future.pointee.error()
            let message = String(cString: future.pointee.__error_messageUnsafe()!)
            pContinuation.pointee.resume(throwing: FirebaseError(code: code, message: message))
          }
        }, UnsafeMutableRawPointer(mutating: continuation))
      }
      future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
    }
  }

  // public func link(with credential: AuthCredential) async throws
  //     -> AuthDataResult {
  //   fatalError("\(#function) not yet implemented")
  // }

  // -linkWithProvider:UIDelegate:completion

  public func unlink(from provider: String) async throws -> User {
    fatalError("\(#function) not yet implemented")
  }

  public mutating func sendEmailVerification() async throws {
    typealias Promise = CheckedContinuation<Void, any Error>
    try await withCheckedThrowingContinuation { (continuation: Promise) in
      let future = self.SendEmailVerification()
      withUnsafePointer(to: continuation) { continuation in
        future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
          let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
          if future.pointee.error() == 0 {
            pContinuation.pointee.resume()
          } else {
            let code = future.pointee.error()
            let message = String(cString: future.pointee.__error_messageUnsafe()!)
            pContinuation.pointee.resume(throwing: FirebaseError(code: code, message: message))
          }
        }, UnsafeMutableRawPointer(mutating: continuation))
      }
      future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
    }
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
