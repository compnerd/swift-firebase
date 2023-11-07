// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Error)
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

public extension Firestore {
    class Encoder {
    public var dateEncodingStrategy: FirebaseDataEncoder.DateEncodingStrategy = .timestamp
    public var dataEncodingStrategy: FirebaseDataEncoder.DataEncodingStrategy = .blob

    public var nonConformingFloatEncodingStrategy: FirebaseDataEncoder
      .NonConformingFloatEncodingStrategy = .throw

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

  class Decoder {
    // FIXME: This should actually be .timestamp, but we can't set it for some reason...
    /// The strategy to use in decoding dates. Defaults to `.timestamp`.
    public var dateDecodingStrategy: FirebaseDataDecoder.DateDecodingStrategy = .secondsSince1970

    /// Firestore decodes Data from `NSData` blobs versus the default .base64 strings.
    public var dataDecodingStrategy: FirebaseDataDecoder.DataDecodingStrategy = .blob

    /// The strategy to use in decoding non-conforming numbers. Defaults to `.throw`.
    public var nonConformingFloatDecodingStrategy: FirebaseDataDecoder
      .NonConformingFloatDecodingStrategy = .throw

    /// The strategy to use for decoding keys. Defaults to `.useDefaultKeys`.
    public var keyDecodingStrategy: FirebaseDataDecoder.KeyDecodingStrategy = .useDefaultKeys

    /// Contextual user-provided information for use during decoding.
    public var userInfo: [CodingUserInfoKey: Any] = [:]

    public func decode<T: Decodable>(_ t: T.Type, from data: Any) throws -> T {
      let decoder = FirebaseDataDecoder()
      decoder.dateDecodingStrategy = dateDecodingStrategy
      decoder.dataDecodingStrategy = dataDecodingStrategy
      decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
      decoder.keyDecodingStrategy = keyDecodingStrategy
      decoder.passthroughTypeResolver = FirestorePassthroughTypes.self
      decoder.userInfo = userInfo
      // configure for firestore
      return try decoder.decode(t, from: data)
    }

    public func decode<T: Decodable>(_ t: T.Type, from data: Any,
                                     in reference: DocumentReference?) throws -> T {
      if let reference = reference {
        userInfo[CodingUserInfoKey.documentRefUserInfoKey] = reference
      }
      return try decode(T.self, from: data)
    }

    public init() {}
  }
}

// FIXME: For some reason this isn't recognized as a type for encoding...
public extension FirebaseDataEncoder.DateEncodingStrategy {
  /// Encode the `Date` as a Firestore `Timestamp`.
  static var timestamp: FirebaseDataEncoder.DateEncodingStrategy {
    return .custom { date, encoder in
      var container = encoder.singleValueContainer()
      try container.encode(Timestamp(date: date))
    }
  }
}
