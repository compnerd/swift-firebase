// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

public struct AuthErrorCode: Error {
  public let rawValue: Int
  public let localizedDescription: String

  internal init(_ params: (code: Int32, message: String)) {
    self.rawValue = Int(params.code)
    localizedDescription = params.message
  }

  private init(_ error: firebase.auth.AuthError) {
    self.init(rawValue: Int(error.rawValue))
  }
}

extension AuthErrorCode: RawRepresentable {
  public typealias RawValue = Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
    localizedDescription = "\(rawValue)"
  }
}

extension AuthErrorCode {
  public static var none: Self { .init(firebase.auth.kAuthErrorNone) }
  public static var unimplemented: Self { .init(firebase.auth.kAuthErrorUnimplemented) }
  public static var invalidCustomToken: Self { .init(firebase.auth.kAuthErrorInvalidCustomToken) }
  public static var customTokenMismatch: Self { .init(firebase.auth.kAuthErrorCustomTokenMismatch) }
  public static var invalidCredential: Self { .init(firebase.auth.kAuthErrorInvalidCredential) }
  public static var userDisabled: Self { .init(firebase.auth.kAuthErrorUserDisabled) }
  public static var accountExistsWithDifferentCredential: Self { .init(firebase.auth.kAuthErrorAccountExistsWithDifferentCredentials) }
  public static var operationNotAllowed: Self { .init(firebase.auth.kAuthErrorOperationNotAllowed) }
  public static var emailAlreadyInUse: Self { .init(firebase.auth.kAuthErrorEmailAlreadyInUse) }
  public static var requiresRecentLogin: Self { .init(firebase.auth.kAuthErrorRequiresRecentLogin) }
  public static var credentialAlreadyInUse: Self { .init(firebase.auth.kAuthErrorCredentialAlreadyInUse) }
  public static var invalidEmail: Self { .init(firebase.auth.kAuthErrorInvalidEmail) }
  public static var wrongPassword: Self { .init(firebase.auth.kAuthErrorWrongPassword) }
  public static var tooManyRequests: Self { .init(firebase.auth.kAuthErrorTooManyRequests) }
  public static var userNotFound: Self { .init(firebase.auth.kAuthErrorUserNotFound) }
  public static var providerAlreadyLinked: Self { .init(firebase.auth.kAuthErrorProviderAlreadyLinked) }
  public static var noSuchProvider: Self { .init(firebase.auth.kAuthErrorNoSuchProvider) }
  public static var invalidUserToken: Self { .init(firebase.auth.kAuthErrorInvalidUserToken) }
  public static var userTokenExpired: Self { .init(firebase.auth.kAuthErrorUserTokenExpired) }
  public static var networkError: Self { .init(firebase.auth.kAuthErrorNetworkRequestFailed) }
  public static var invalidAPIKey: Self { .init(firebase.auth.kAuthErrorInvalidApiKey) }
  public static var appNotAuthorized: Self { .init(firebase.auth.kAuthErrorAppNotAuthorized) }
  public static var userMismatch: Self { .init(firebase.auth.kAuthErrorUserMismatch) }
  public static var weakPassword: Self { .init(firebase.auth.kAuthErrorWeakPassword) }
  public static var noSignedInUser: Self { .init(firebase.auth.kAuthErrorNoSignedInUser) }
  public static var apiNotAvailable: Self { .init(firebase.auth.kAuthErrorApiNotAvailable) }
  public static var expiredActionCode: Self { .init(firebase.auth.kAuthErrorExpiredActionCode) }
  public static var invalidActionCode: Self { .init(firebase.auth.kAuthErrorInvalidActionCode) }
  public static var invalidMessagePayload: Self { .init(firebase.auth.kAuthErrorInvalidMessagePayload) }
  public static var invalidPhoneNumber: Self { .init(firebase.auth.kAuthErrorInvalidPhoneNumber) }
  public static var missingPhoneNumber: Self { .init(firebase.auth.kAuthErrorMissingPhoneNumber) }
  public static var invalidRecipientEmail: Self { .init(firebase.auth.kAuthErrorInvalidRecipientEmail) }
  public static var invalidSender: Self { .init(firebase.auth.kAuthErrorInvalidSender) }
  public static var invalidVerificationCode: Self { .init(firebase.auth.kAuthErrorInvalidVerificationCode) }
  public static var invalidVerificationID: Self { .init(firebase.auth.kAuthErrorInvalidVerificationId) }
  public static var missingVerificationCode: Self { .init(firebase.auth.kAuthErrorMissingVerificationCode) }
  public static var missingVerificationID: Self { .init(firebase.auth.kAuthErrorMissingVerificationId) }
  public static var missingEmail: Self { .init(firebase.auth.kAuthErrorMissingEmail) }
  public static var missingPassword: Self { .init(firebase.auth.kAuthErrorMissingPassword) }
  public static var quotaExceeded: Self { .init(firebase.auth.kAuthErrorQuotaExceeded) }
  public static var retryPhoneAuth: Self { .init(firebase.auth.kAuthErrorRetryPhoneAuth) }
  public static var sessionExpired: Self { .init(firebase.auth.kAuthErrorSessionExpired) }
  public static var appNotVerified: Self { .init(firebase.auth.kAuthErrorAppNotVerified) }
  public static var appVerificationUserInteractionFailure: Self { .init(firebase.auth.kAuthErrorAppVerificationFailed) }
  public static var captchaCheckFailed: Self { .init(firebase.auth.kAuthErrorCaptchaCheckFailed) }
  public static var invalidAppCredential: Self { .init(firebase.auth.kAuthErrorInvalidAppCredential) }
  public static var missingAppCredential: Self { .init(firebase.auth.kAuthErrorMissingAppCredential) }
  public static var invalidClientID: Self { .init(firebase.auth.kAuthErrorInvalidClientId) }
  public static var invalidContinueURI: Self { .init(firebase.auth.kAuthErrorInvalidContinueUri) }
  public static var missingContinueURI: Self { .init(firebase.auth.kAuthErrorMissingContinueUri) }
  public static var keychainError: Self { .init(firebase.auth.kAuthErrorKeychainError) }
  public static var missingAppToken: Self { .init(firebase.auth.kAuthErrorMissingAppToken) }
  public static var missingIosBundleID: Self { .init(firebase.auth.kAuthErrorMissingIosBundleId) }
  public static var notificationNotForwarded: Self { .init(firebase.auth.kAuthErrorNotificationNotForwarded) }
  public static var unauthorizedDomain: Self { .init(firebase.auth.kAuthErrorUnauthorizedDomain) }
  public static var webContextAlreadyPresented: Self { .init(firebase.auth.kAuthErrorWebContextAlreadyPresented) }
  public static var webContextCancelled: Self { .init(firebase.auth.kAuthErrorWebContextCancelled) }
  public static var dynamicLinkNotActivated: Self { .init(firebase.auth.kAuthErrorDynamicLinkNotActivated) }
  public static var cancelled: Self { .init(firebase.auth.kAuthErrorCancelled) }
  public static var invalidProviderID: Self { .init(firebase.auth.kAuthErrorInvalidProviderId) }
  public static var webInternalError: Self { .init(firebase.auth.kAuthErrorWebInternalError) }
  // There's a typo in the Firebase error, carrying it over here.
  public static var webStorateUnsupported: Self { .init(firebase.auth.kAuthErrorWebStorateUnsupported) }
  public static var tenantIDMismatch: Self { .init(firebase.auth.kAuthErrorTenantIdMismatch) }
  public static var unsupportedTenantOperation: Self { .init(firebase.auth.kAuthErrorUnsupportedTenantOperation) }
  public static var invalidDynamicLinkDomain: Self { .init(firebase.auth.kAuthErrorInvalidLinkDomain) }
  public static var rejectedCredential: Self { .init(firebase.auth.kAuthErrorRejectedCredential) }
  public static var phoneNumberNotFound: Self { .init(firebase.auth.kAuthErrorPhoneNumberNotFound) }
  public static var invalidTenantID: Self { .init(firebase.auth.kAuthErrorInvalidTenantId) }
  public static var missingClientIdentifier: Self { .init(firebase.auth.kAuthErrorMissingClientIdentifier) }
  public static var missingMultiFactorSession: Self { .init(firebase.auth.kAuthErrorMissingMultiFactorSession) }
  public static var missingMultiFactorInfo: Self { .init(firebase.auth.kAuthErrorMissingMultiFactorInfo) }
  public static var invalidMultiFactorSession: Self { .init(firebase.auth.kAuthErrorInvalidMultiFactorSession) }
  public static var multiFactorInfoNotFound: Self { .init(firebase.auth.kAuthErrorMultiFactorInfoNotFound) }
  public static var adminRestrictedOperation: Self { .init(firebase.auth.kAuthErrorAdminRestrictedOperation) }
  public static var unverifiedEmail: Self { .init(firebase.auth.kAuthErrorUnverifiedEmail) }
  public static var secondFactorAlreadyEnrolled: Self { .init(firebase.auth.kAuthErrorSecondFactorAlreadyEnrolled) }
  public static var maximumSecondFactorCountExceeded: Self { .init(firebase.auth.kAuthErrorMaximumSecondFactorCountExceeded) }
  public static var unsupportedFirstFactor: Self { .init(firebase.auth.kAuthErrorUnsupportedFirstFactor) }
  public static var emailChangeNeedsVerification: Self { .init(firebase.auth.kAuthErrorEmailChangeNeedsVerification) }
  #if INTERNAL_EXPERIMENTAL
  public static var invalidEventHandler: Self { .init(firebase.auth.kAuthErrorInvalidEventHandler) }
  public static var federatedProviderAlreadyInUse: Self { .init(firebase.auth.kAuthErrorFederatedProviderAlreadyInUse) }
  public static var invalidAuthenticatedUserData: Self { .init(firebase.auth.kAuthErrorInvalidAuthenticatedUserData) }
  public static var federatedSignInUserInteractionFailure: Self { .init(firebase.auth.kAuthErrorFederatedSignInUserInteractionFailure) }
  public static var missingOrInvalidNonce: Self { .init(firebase.auth.kAuthErrorMissingOrInvalidNonce) }
  public static var userCancelled: Self { .init(firebase.auth.kAuthErrorUserCancelled) }
  public static var unsupportedPassthroughOperation: Self { .init(firebase.auth.kAuthErrorUnsupportedPassthroughOperation) }
  public static var tokenRefreshUnavailable: Self { .init(firebase.auth.kAuthErrorTokenRefreshUnavailable) }
  #endif

  // Errors that are not represented in the C++ SDK, but are
  // present in the reference API.
  public static var missingAndroidPackageName: Self { .init(rawValue: 17037) }
  public static var webNetworkRequestFailed: Self { .init(rawValue: 17061) }
  public static var webSignInUserInteractionFailure: Self { .init(rawValue: 17063) }
  public static var localPlayerNotAuthenticated: Self { .init(rawValue: 17066) }
  public static var nullUser: Self { .init(rawValue: 17067) }
  public static var gameKitNotLinked: Self { .init(rawValue: 17076) }
  public static var secondFactorRequired: Self { .init(rawValue: 17078) }
  public static var blockingCloudFunctionError: Self { .init(rawValue: 17105) }
  public static var internalError: Self { .init(rawValue: 17999) }
  public static var malformedJWT: Self { .init(rawValue: 18000) }
}

extension AuthErrorCode: Equatable {}

extension AuthErrorCode {
  // The Obj C API provides this type as well, so provide it here for consistency.
  public typealias Code = AuthErrorCode

  // This allows us to re-expose self as a code similarly
  // to what the Firebase SDK does when it creates the
  // underlying NSErrors on iOS/macOS.
  public var code: Code {
    return self
  }

  public init(_ code: Code) {
    self.init(rawValue: code.rawValue)
  }
}
