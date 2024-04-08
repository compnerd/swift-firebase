// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

@available(*, unavailable)
public enum AuthAPNSTokenType: Int {
  case FIRAuthAPNSTokenTypeUnknown
  case FIRAuthAPNSTokenTypeSandbox
  case FIRAuthAPNSTokenTypeProd
}

public final class Auth {
  let impl: UnsafeMutablePointer<firebase.auth.Auth>

  init(_ impl: UnsafeMutablePointer<firebase.auth.Auth>) {
    self.impl = impl
  }

  public var app: FirebaseApp? {
    impl.pointee.__appUnsafe()
  }

  public var currentUser: User? {
    let user = impl.pointee.current_user()
    guard user.is_valid() else { return nil }
    return .init(user)
  }

  public var languageCode: String? {
    get {
      let code = String(impl.pointee.language_code())
      guard !code.isEmpty else { return nil }
      return String(code)
    }
    set { impl.pointee.set_language_code(newValue) }
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
    .init(firebase.auth.Auth.GetAuth(app, nil))
  }

  public func updateCurrentUser(_ user: User, completion: ((Error?) -> Void)?) {
    fatalError("\(#function) not yet implemented")
  }

  public func updateCurrentUser(_ user: User) async throws {
    fatalError("\(#function) not yet implemented")
  }

  public func fetchSignInMethods(forEmail email: String, completion: (([String]?, Error?) -> Void)?) {
    fetchSignInMethodsImpl(forEmail: email) { providers, error in
      if let completion {
        DispatchQueue.main.async {
          completion(providers, error)
        }
      }
    }
  }

  public func fetchSignInMethods(forEmail email: String) async throws
      -> [String] {
    try await withCheckedThrowingContinuation { continuation in
      fetchSignInMethodsImpl(forEmail: email) { providers, error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: providers ?? [])
        }
      }
    }
  }

  private func fetchSignInMethodsImpl(forEmail email: String, completion: @escaping ([String]?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.auth.auth_fetch_providers_for_email(impl, email)
    future.setCompletion({
      let (result, error) = future.resultAndError { AuthErrorCode($0) }
      var providers: [String]?
      if let result {
        providers = result.providers.map(String.init)
      } else {
        providers = nil
      }
      completion(providers, error)
    })
  }

  public func signIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
    signInImpl(withEmail: email, password: password) { data, error in
      if let completion {
        DispatchQueue.main.async {
          completion(data, error)
        }
      }
    }
  }

  public func signIn(withEmail email: String, password: String) async throws
      -> AuthDataResult {
    try await withCheckedThrowingContinuation { continuation in
      signInImpl(withEmail: email, password: password) { data, error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: data ?? .init())
        }
      }
    }
  }

  private func signInImpl(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.auth.auth_sign_in_with_email_and_password(impl, email, password)
    future.setCompletion({
      let (result, error) = future.resultAndError { AuthErrorCode($0) }
      var data: AuthDataResult?
      if let result {
        data = .init(result)
      } else {
        data = nil
      }
      completion(data, error)
    })
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

  public func createUser(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
    createUserImpl(withEmail: email, password: password) { data, error in
      if let completion {
        DispatchQueue.main.async {
          completion(data, error)
        }
      }
    }
  }

  public func createUser(withEmail email: String, password: String) async throws
      -> AuthDataResult {
    try await withCheckedThrowingContinuation { continuation in
      createUserImpl(withEmail: email, password: password) { data, error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: data ?? .init())
        }
      }
    }
  }

  private func createUserImpl(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.auth.auth_create_user_with_email_and_password(impl, email, password)
    future.setCompletion({
      let (result, error) = future.resultAndError { AuthErrorCode($0) }
      var data: AuthDataResult?
      if let result {
        data = .init(result)
      } else {
        data = nil
      }
      completion(data, error)
    })
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

  public func sendPasswordReset(withEmail email: String, completion: ((Error?) -> Void)?) {
    sendPasswordResetImpl(withEmail: email) { error in
      if let completion {
        DispatchQueue.main.async {
          completion(error)
        }
      }
    }
  }

  public func sendPasswordReset(withEmail email: String) async throws {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
      sendPasswordResetImpl(withEmail: email) { error in
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume()
        }
      }
    }
  }

  private func sendPasswordResetImpl(withEmail email: String, completion: @escaping (Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.auth.auth_send_password_reset_email(impl, email)
    future.setCompletion({
      let (_, error) = future.resultAndError { AuthErrorCode($0) }
      completion(error)
    })
  }

  // public func sendPasswordReset(withEmail email: String,
  //                               actionCodeSettings: ActionCodeSettings) async throws {
  //   fatalError("\(#function) not yet implemented")
  // }

  // public func sendSignInLink(toEmail email: String,
  //                            actionCodeSettings: ActionCodeSettings) async throws {
  //   fatalError("\(#function) not yet implemented")
  // }

  @discardableResult public func signOut() throws -> Bool {
    impl.pointee.SignOut()
    return true
  }

  public func isSignIn(withEmailLink link: String) -> Bool {
    fatalError("\(#function) not yet implemented")
  }

  public func addStateDidChangeListener(_ listener: @escaping (Auth, User?) -> Void)
      -> AuthStateDidChangeListenerHandle {
    let handle = _AuthStateDidChangeListenerHandle(listener)
    impl.pointee.AddAuthStateListener(handle.listener)
    return handle
  }

  public func removeStateDidChangeListener(_ listenerHandle: AuthStateDidChangeListenerHandle) {
    guard let handle = listenerHandle as? _AuthStateDidChangeListenerHandle else { return }
    impl.pointee.RemoveAuthStateListener(handle.listener)
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
