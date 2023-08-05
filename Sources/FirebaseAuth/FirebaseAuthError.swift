// SPDX-License-Identifier: BSD-3-Clause

import Foundation

public struct AuthError {
}

extension AuthError: Error {
}

extension AuthError {
  public enum Code: Int {
    case invalidCustomToken = 17000
    case customTokenMismatch = 17002
    case invalidCredential = 17004
    case userDisabled = 17005
    case operationNotAllowed = 17006
    case emailAlreadyInUse = 17007
    case invalidEmail = 17008
    case wrongPassword = 17009
    case tooManyRequests = 17010
    case userNotFound = 17011
    case accountExistsWithDifferentCredential = 17012
    case requiresRecentLogin = 17014
    case providerAlreadyLinked = 17015
    case noSuchProvider = 17016
    case invalidUserToken = 17017
    case networkError = 17020
    case userTokenExpired = 17021
    case invalidAPIKey = 17023
    case userMismatch = 17024
    case credentialAlreadyInUse = 17025
    case weakPassword = 17026
    case appNotAuthorized = 17028
    case expiredActionCode = 17029
    case invalidActionCode = 17030
    case invalidMessagePayload = 17031
    case invalidSender = 17032
    case invalidRecipientEmail = 17033
    case missingEmail = 17034
    case missingIosBundleID = 17036
    case missingAndroidPackageName = 17037
    case unauthorizedDomain = 17038
    case invalidContinueURI = 17039
    case missingContinueURI = 17040
    case missingPhoneNumber = 17041
    case invalidPhoneNumber = 17042
    case missingVerificationCode = 17043
    case invalidVerificationCode = 17044
    case missingVerificationID = 17045
    case invalidVerificationID = 17046
    case missingAppCredential = 17047
    case invalidAppCredential = 17048
    case sessionExpired = 17051
    case quotaExceeded = 17052
    case missingAppToken = 17053
    case notificationNotForwarded = 17054
    case appNotVerified = 17055
    case captchaCheckFailed = 17056
    case webContextAlreadyPresented = 17057
    case webContextCancelled = 17058
    case appVerificationUserInteractionFailure = 17059
    case invalidClientID = 17060
    case webNetworkRequestFailed = 17061
    case webInternalError = 17062
    case webSignInUserInteractionFailure = 17063
    case localPlayerNotAuthenticated = 17066
    case nullUser = 17067
    case dynamicLinkNotActivated = 17068
    case invalidProviderID = 17071
    case tenantIDMismatch = 17072
    case unsupportedTenantOperation = 17073
    case invalidDynamicLinkDomain = 17074
    case rejectedCredential = 17075
    case gameKitNotLinked = 17076
    case secondFactorRequired = 17078
    case missingMultiFactorSession = 17081
    case missingMultiFactorInfo = 17082
    case invalidMultiFactorSession = 17083
    case multiFactorInfoNotFound = 17084
    case adminRestrictedOperation = 17085
    case unverifiedEmail = 17086
    case secondFactorAlreadyEnrolled = 17087
    case maximumSecondFactorCountExceeded = 17088
    case unsupportedFirstFactor = 17089
    case emailChangeNeedsVerification = 17090
    case missingOrInvalidNonce = 17094
    case blockingCloudFunctionError = 17105
    case missingClientIdentifier = 17993
    case keychainError = 17995
    case internalError = 17999
    case malformedJWT = 18000
  }
}
