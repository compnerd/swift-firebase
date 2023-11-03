// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Error)
import FirebaseCore

import CxxShim
import Foundation

enum MyError: Error {
  case something
}

public extension Firestore {
  class Decoder {
    var userInfo: [CodingUserInfoKey: Any] = [:]

    public init() {}

    func decode<T: Decodable>(_ t: T.Type, from data: Any) throws -> T {
      throw MyError.something
    }

    func decode<T: Decodable>(_ t: T.Type, from data: Any, in reference: DocumentReference?) throws -> T {
      if let reference {
        userInfo[CodingUserInfoKey.documentRefUserInfoKey] = reference
      }
      return try decode(t, from: data)
    }
  }
}

extension CodingUserInfoKey {
  static let documentRefUserInfoKey = CodingUserInfoKey(rawValue: "DocumentRefUserInfoKey")!
}