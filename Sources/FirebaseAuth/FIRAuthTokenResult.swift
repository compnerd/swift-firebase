// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import Foundation

public struct AuthTokenResult {
  public let token: String

  public let expirationDate: Date

  public let authDate: Date

  public let issuedAtDate: Date

  public let signInProvider: String

  public let signInSecondFactor: String

  public let claims: [String:Any]

  internal init(_ token: String) throws {
    let components = token.components(separatedBy: ".")
    // The JWT should have three components
    guard components.count == 3 else {
      throw NSError(domain: "com.google.firebase.auth",
                    code: AuthError.Code.malformedJWT.rawValue,
                    userInfo: [NSLocalizedDescriptionKey:"Failed to decode token"])
    }

    var payload = components[1].replacing("_", with: "/")
                               .replacing("-", with: "+")
    // Pad to 4 character alignment for base64 decoding
    if payload.count % 4 != 0 {
      payload.append(String(repeating: "=", count: 4 - payload.count % 4))
    }

    guard let data = Data(base64Encoded: payload,
                          options: .ignoreUnknownCharacters) else {
      throw NSError(domain: "com.google.firebase.auth",
                    code: AuthError.Code.malformedJWT.rawValue,
                    userInfo: [NSLocalizedDescriptionKey:"Failed to decode token payload"])
    }

    let options: JSONSerialization.ReadingOptions =
        [.mutableContainers, .allowFragments]
    guard let contents =
        try? JSONSerialization.jsonObject(with: data, options: options)
            as? [String:Any] else {
      throw NSError(domain: "com.google.firebase.auth",
                    code: AuthError.Code.malformedJWT.rawValue,
                    userInfo: [NSLocalizedDescriptionKey:"Failed to deserialise token payload"])
    }

    // These are dates since 00:00:00 January 1 1970, as described by the
    // Terminology section in the JWT spec.
    // https://tools.ietf.org/html/rfc7519
    guard let authDate = contents["auth_time"] as? TimeInterval,
          let expirationDate = contents["exp"] as? TimeInterval,
          let issueDate = contents["iat"] as? TimeInterval else {
      throw NSError(domain: "com.google.firebase.auth",
                    code: AuthError.Code.malformedJWT.rawValue,
                    userInfo: [NSLocalizedDescriptionKey:"Missing fields in token payload"])
    }

    self.token = token
    self.expirationDate = Date(timeIntervalSince1970: expirationDate)
    self.authDate = Date(timeIntervalSince1970: authDate)
    self.issuedAtDate = Date(timeIntervalSince1970: issueDate)
    self.signInProvider = contents["sign_in_provider"] as? String ?? ""
    self.signInSecondFactor = contents["sign_in_second_factor"] as? String ?? ""
    self.claims = contents
  }
}
