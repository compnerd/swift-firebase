// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Internal)
import FirebaseCore

import CxxShim
import Foundation

public typealias Auth = UnsafeMutablePointer<firebase.auth.Auth>

@available(*, unavailable)
public enum AuthAPNSTokenType: Int {
  case FIRAuthAPNSTokenTypeUnknown
  case FIRAuthAPNSTokenTypeSandbox
  case FIRAuthAPNSTokenTypeProd
}

extension Auth {
  public var app: FirebaseApp? {
    self.pointee.__appUnsafe()
  }

  public var currentUser: User? {
    let user = self.pointee.current_user()
    guard user.is_valid() else { return nil }
    return user
  }

  public var languageCode: String? {
    get {
      let code = String(self.pointee.language_code())
      guard !code.isEmpty else { return nil }
      return String(code)
    }
    set { self.pointee.set_language_code(newValue) }
  }

  // @available(*, unavailable)
  // public var settings: AuthSettings? { get set }

  // @available(*, unavailable)
  // public var userAccessGroup: String? { get }

  // @available(*, unavailable)
  // public var shareAuthStateAcrossDevices: Bool { get set }

  // @available(*, unavailable)
  // public var tennantID: String? { get set }

  // @available(*, unavailable)
  // public var apnsToken: Data? { get set }

  public static func auth() -> Auth {
    // TODO(compnerd) convert this to an exception
    guard let application = firebase.App.GetInstance() else {
      fatalError("no default application")
    }
    return auth(app: application)
  }

  public static func auth(app: FirebaseApp) -> Auth {
    firebase.auth.Auth.GetAuth(app, nil)
  }

  public func updateCurrentUser(_ user: User) async throws {
    fatalError("\(#function) not yet implemented")
  }

  public func fetchSignInMethods(forEmail email: String) async throws
      -> [String] {
    typealias Promise = CheckedContinuation<UnsafeMutablePointer<firebase.auth.Auth.FetchProvidersResult>, any Error>
    let providers = try await withCheckedThrowingContinuation { (continuation: Promise) in
      let future = self.pointee.FetchProvidersForEmail(email)
      withUnsafePointer(to: continuation) { continuation in
        future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
          let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
          if future.pointee.error() == 0 {
            pContinuation.pointee.resume(returning: .init(mutating: future.pointee.__resultUnsafe()))
          } else {
            let code = future.pointee.error()
            let message = String(cString: future.pointee.__error_messageUnsafe()!)
            pContinuation.pointee.resume(throwing: FirebaseError(code: code, message: message))
          }
        }, UnsafeMutableRawPointer(mutating: continuation))
      }
      future.Wait(firebase.FutureBase.kWaitTimeoutInfinite)
    }

#if SR70253
    // Workaround compiler crash (SR70253) by not using compactMap
    // which uses std.vector<std.string>::const_iterator.
    var result: [String] = []
    for idx in 0..<providers.pointee.providers.size() {
      result.append(String(providers.pointee.providers[idx]))
    }
    return result
#else
    return providers.pointee.providers.compactMap(String.init)
#endif
  }

  public func signIn(withEmail email: String, password: String) async throws
      -> AuthDataResult {
    typealias Promise = CheckedContinuation<AuthDataResult, any Error>
    return try await withCheckedThrowingContinuation { (continuation: Promise) in
      let future = self.pointee.SignInWithEmailAndPassword(email, password)
      withUnsafePointer(to: continuation) { continuation in
        future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
          let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
          if future.pointee.error() == 0 {
            pContinuation.pointee.resume(returning: .init(mutating: future.pointee.__resultUnsafe()))
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

  public func signIn(withEmail email: String, link: String) async throws
      -> AuthDataResult {
    fatalError("\(#function) not yet implemented")
  }

  // signInWithProvider:UIDelegate:completion:

  // public func signIn(with credential: AuthCredential) async throws
  //     -> AuthDataResult {
  //   fatalError("\(#function) not yet implemented")
  // }

  public func signInAnonymously() async throws -> AuthDataResult {
    fatalError("\(#function) not yet implemented")
  }

  public func signIn(withCustomToken token: String) async throws
      -> AuthDataResult {
    fatalError("\(#function) not yet implemented")
  }

  public func createUser(withEmail email: String, password: String) async throws
      -> AuthDataResult {
    typealias Promise = CheckedContinuation<AuthDataResult, any Error>
    return try await withCheckedThrowingContinuation { (continuation: Promise) in
      let future = self.pointee.CreateUserWithEmailAndPassword(email, password)
      withUnsafePointer(to: continuation) { continuation in
        future.OnCompletion_SwiftWorkaround({ future, pvContinuation in
          let pContinuation = pvContinuation?.assumingMemoryBound(to: Promise.self)
          if future.pointee.error() == 0 {
            pContinuation.pointee.resume(returning: .init(mutating: future.pointee.__resultUnsafe()))
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

  public func confirmPasswordReset(withCode code: String,
                                   newPassword: String) async throws {
    fatalError("\(#function) not yet implemented")
  }

  // public func checkActionCode(_ code: String) async throws -> ActionCodeInfo {
  //   fatalError("\(#function) not yet implemented")
  // }

  public func verifyPasswordResetCode(_ code: String) async throws -> String {
    fatalError("\(#function) not yet implemented")
  }

  public func applyActionCode(_ code: String) async throws {
    fatalError("\(#function) not yet implemented")
  }

  public func sendPasswordReset(withEmail email: String) async throws {
    typealias Promise = CheckedContinuation<Void, any Error>
    return try await withCheckedThrowingContinuation { (continuation: Promise) in
      let future = self.pointee.SendPasswordResetEmail(email)
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

  // public func sendPasswordReset(withEmail email: String,
  //                               actionCodeSettings: ActionCodeSettings) async throws {
  //   fatalError("\(#function) not yet implemented")
  // }

  // public func sendSignInLink(toEmail email: String,
  //                            actionCodeSettings: ActionCodeSettings) async throws {
  //   fatalError("\(#function) not yet implemented")
  // }

  public func signOut() throws {
    self.pointee.SignOut()
  }

  public func isSignIn(withEmailLink link: String) -> Bool {
    fatalError("\(#function) not yet implemented")
  }

  public func addStateDidChangeListener(_ listener: @escaping (Auth, User?) -> Void)
      -> AuthStateDidChangeListenerHandle {
    let handle = _AuthStateDidChangeListenerHandle(listener)
    self.pointee.AddAuthStateListener(handle.listener)
    return handle
  }

  public func removeStateDidChangeListener(_ listenerHandle: AuthStateDidChangeListenerHandle) {
    guard let handle = listenerHandle as? _AuthStateDidChangeListenerHandle else { return }
    self.pointee.RemoveAuthStateListener(handle.listener)
  }

  // public func addIDTokenDidChangeListener(_ listener: @escaping (Auth, User?) -> Void)
  //     -> IDTokenDidChangeListenerHandle {
  //   fatalError("\(#function) not yet implemented")
  // }

  // public func removeIDTokenDidChangeListener(_ listenerHandle: IDTokenDidChangeListenerHandle) {
  //   fatalError("\(#function) not yet implemented")
  // }

  public func useAppLangauge() {
    fatalError("\(#function) not yet implemented")
  }

  public func useEmulator(withHost host: String, port: Int) {
    fatalError("\(#function) not yet implemented")
  }

  public func canHandle(_ url: URL) -> Bool {
    fatalError("\(#function) not yet implemented")
  }

  @available(*, unavailable)
  public func setAPNSToken(_ token: Data, type: AuthAPNSTokenType) {
  }

  public func canHandleNotification(_ userInfo: [AnyHashable:Any]) -> Bool {
    fatalError("\(#function) not yet implemented")
  }

  public func revokeToken(withAuthorizationCode authorizationCode: String) async throws {
    fatalError("\(#function) not yet implemented")
  }

  public func useUserAccessGroup(_ accessGroup: String?) throws {
    fatalError("\(#function) not yet implemented")
  }

  public func getStoredUser(forAccessGroup accessGroup: String?) throws -> User? {
    fatalError("\(#function) not yet implemented")
  }
}
