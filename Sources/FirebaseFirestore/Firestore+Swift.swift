// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Internal)
import FirebaseCore

import CxxShim
import Foundation

public typealias Firestore = UnsafeMutablePointer<firebase.firestore.Firestore>

extension Firestore {
  public static func firestore() -> Firestore {
    guard let application = firebase.App.GetInstance() else {
      fatalError("no default application")
    }

    return firestore(app: application)
  }

  public static func firestore(app: FirebaseApp) -> Firestore {
    guard let instance = firebase.firestore.Firestore.GetInstance(app, nil) else {
      fatalError("Invalid Firestore Instance")
    }

    return instance
  }

  public func document(_ documentPath: String) -> DocumentReference {
    swift_firebase.swift_cxx_shims.firebase.firestore.firestore_document(self, std.string(documentPath))
  }

  public func collection(_ collectionPath: String) -> CollectionReference {
    swift_firebase.swift_cxx_shims.firebase.firestore.firestore_collection(self, std.string(collectionPath))
  }
}

// An extension that adds the encoder and decoder functions required
// to serialize and deserialize documents in Firebase. These are mostly
// copy of the Swift implementation that's available within firebase-ios-sdk
//
// The `FirebaseDataDecoder` is a heavily forked version of the Swift JSONEncoder/Decoder
// this extension creates classes that can be configured in a similar fashion to the standard
// encoder/decoders but with Firebase specific options like for data encoding, extended
// date format options, etc.
//
// We are re-exposing these to maximize compatibility with existing Firestore APIs that might
// depend on these being the same access level and shape.
extension Firestore {
  public class Encoder {
    public var dateEncodingStrategy: FirebaseDataEncoder.DateEncodingStrategy = .timestamp
    public var dataEncodingStrategy: FirebaseDataEncoder.DataEncodingStrategy = .blob
    public var nonConformingFloatEncodingStrategy: FirebaseDataEncoder.NonConformingFloatEncodingStrategy = .throw
    public var keyEncodingStrategy: FirebaseDataEncoder.KeyEncodingStrategy = .useDefaultKeys
    public var userInfo: [CodingUserInfoKey: Any] = [:]

    public func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
      let encoder = FirebaseDataEncoder()
      // Configure the encoder to the set values
      encoder.dateEncodingStrategy = dateEncodingStrategy
      encoder.dataEncodingStrategy = dataEncodingStrategy
      encoder.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
      encoder.keyEncodingStrategy = keyEncodingStrategy
      encoder.passthroughTypeResolver = FirestorePassthroughTypes.self
      encoder.userInfo = userInfo

      // Decode the document correctly, or throw an error describing
      // what sort of bad thing has happened.
      let encoded = try encoder.encode(value)
      guard let dictionaryValue = encoded as? [String: Any] else {
        throw EncodingError
          .invalidValue(value,
                        EncodingError.Context(codingPath: [],
                                              debugDescription: "Top-level \(T.self) is not allowed."))
      }
      return dictionaryValue
    }

    public init() {}
  }

  public class Decoder {
    public var dateDecodingStrategy: FirebaseDataDecoder.DateDecodingStrategy = .timestamp
    public var dataDecodingStrategy: FirebaseDataDecoder.DataDecodingStrategy = .blob
    public var nonConformingFloatDecodingStrategy: FirebaseDataDecoder.NonConformingFloatDecodingStrategy = .throw
    public var keyDecodingStrategy: FirebaseDataDecoder.KeyDecodingStrategy = .useDefaultKeys
    public var userInfo: [CodingUserInfoKey: Any] = [:]

    public func decode<T: Decodable>(_ t: T.Type, from data: Any) throws -> T {
      let decoder = FirebaseDataDecoder()
      decoder.dateDecodingStrategy = dateDecodingStrategy
      decoder.dataDecodingStrategy = dataDecodingStrategy
      decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
      decoder.keyDecodingStrategy = keyDecodingStrategy
      decoder.passthroughTypeResolver = FirestorePassthroughTypes.self
      decoder.userInfo = userInfo
      return try decoder.decode(t, from: data)
    }

    public func decode<T: Decodable>(_ t: T.Type, from data: Any, in reference: DocumentReference?) throws -> T {
      if let reference = reference {
        userInfo[CodingUserInfoKey.documentRefUserInfoKey] = reference
      }
      return try decode(T.self, from: data)
    }

    public init() {}
  }
}

extension FirebaseDataEncoder.DateEncodingStrategy {
  public static var timestamp: FirebaseDataEncoder.DateEncodingStrategy {
    return .custom { date, encoder in
      var container = encoder.singleValueContainer()
      try container.encode(Timestamp(date: date))
    }
  }
}

extension FirebaseDataDecoder.DateDecodingStrategy {
  public static var timestamp: FirebaseDataDecoder.DateDecodingStrategy {
    return .custom { decoder in
      let container = try decoder.singleValueContainer()
      let value = try container.decode(Timestamp.self)
      return value.dateValue()
    }
  }
}
