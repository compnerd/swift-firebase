// SPDX-License-Identifier: BSD-3-Clause

import Foundation

public enum AuthErrorCode: Int {
  case invalidCustomToken = 2
  case customTokenMismatch = 3
  case invalidCredential = 4
  case userDisabled = 5
  case accountExistsWithDifferentCredential = 6
  case operationNotAllowed = 7
  case emailAlreadyInUse = 8
  case requiresRecentLogin = 9
  case credentialAlreadyInUse = 10
  case invalidEmail = 11
  case wrongPassword = 12
  case tooManyRequests = 13
  case userNotFound = 14
  case providerAlreadyLinked = 15
  case noSuchProvider = 16
  case invalidUserToken = 17
  case userTokenExpired = 18
  case networkError = 19
  case invalidAPIKey = 20
  case appNotAuthorized = 21
  case userMismatch = 22
  case weakPassword = 23
  case noSignedInUser = 24
  case apiNotAvailable = 25
  case expiredActionCode = 26
  case invalidActionCode = 27
  case invalidMessagePayload = 28
  case invalidPhoneNumber = 29
  case missingPhoneNumber = 30
  case invalidRecipientEmail = 31
  case invalidSender = 32
  case invalidVerificationCode = 33
  case invalidVerificationID = 34
  case missingVerificationCode = 35
  case missingVerificationID = 36
  case missingEmail = 37
  case missingPassword = 38
  case quotaExceeded = 39
  case retryPhoneAuth = 40
  case sessionExpired = 41
  case appNotVerified = 42
  case appVerificationUserInteractionFailure = 43
  case captchaCheckFailed = 44
  case invalidAppCredential = 45
  case missingAppCredential = 46
  case invalidClientID = 47
  case invalidContinueURI = 48
  case missingContinueURI = 49
  case keychainError = 50
  case missingAppToken = 51
  case missingIosBundleID = 52
  case notificationNotForwarded = 53
  case unauthorizedDomain = 54
  case webContextAlreadyPresented = 55
  case webContextCancelled = 56
  case dynamicLinkNotActivated = 57
  case cancelled = 58
  case invalidProviderID = 59
  case webInternalError = 60
  // There's a typo in the Firebase error, carrying it over here.
  case webStorateUnsupported = 61
  case tenantIDMismatch = 62
  case unsupportedTenantOperation = 63
  case invalidDynamicLinkDomain = 64
  case rejectedCredential = 65
  case phoneNumberNotFound = 66
  case invalidTenantID = 67
  case missingClientIdentifier = 68
  case missingMultiFactorSession = 69
  case missingMultiFactorInfo = 70
  case invalidMultiFactorSession = 71
  case multiFactorInfoNotFound = 72
  case adminRestrictedOperation = 73
  case unverifiedEmail = 74
  case secondFactorAlreadyEnrolled = 75
  case maximumSecondFactorCountExceeded = 76
  case unsupportedFirstFactor = 77
  case emailChangeNeedsVerification = 78
  #if INTERNAL_EXPERIMENTAL
  case invalidEventHandler = 79
  case federatedProviderAlreadyInUse = 80
  case invalidAuthenticatedUserData = 81
  case federatedSignInUserInteractionFailure = 82
  case missingOrInvalidNonce = 83
  case userCancelled = 84
  case unsupportedPassthroughOperation = 85
  case tokenRefreshUnavailable = 86
  #endif

  // Errors that are not represented in the C++ SDK, but are
  // present in the reference API.
  case missingAndroidPackageName = 17037
  case webNetworkRequestFailed = 17061
  case webSignInUserInteractionFailure = 17063
  case localPlayerNotAuthenticated = 17066
  case nullUser = 17067
  case gameKitNotLinked = 17076
  case secondFactorRequired = 17078
  case blockingCloudFunctionError = 17105
  case internalError = 17999
  case malformedJWT = 18000
}

extension AuthErrorCode: Error {}
extension AuthErrorCode {
  // This allows us to re-expose self as a code similarly
  // to what the Firebase SDK does when it creates the
  // underlying NSErrors on iOS/macOS.
  public var code: AuthErrorCode {
    return self
  }
}
