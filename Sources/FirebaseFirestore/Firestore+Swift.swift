// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public typealias Firestore = UnsafeMutablePointer<firebase.firestore.Firestore>

// On Apple platforms, this is defined by Foundation using AutoreleasingUnsafeMutablePointer.
// That type is specific to the ObjC runtime, so we don't have access to it. Use this instead.
public typealias NSErrorPointer = UnsafeMutablePointer<NSError?>?

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

  public func runTransaction(_ updateBlock: @escaping (Transaction, NSErrorPointer) -> Any, completion: @escaping (Any?, Error?) -> Void) {
    runTransaction(with: nil, block: updateBlock, completion: completion)
  }

  public func runTransaction(_ updateBlock: @escaping (Transaction, NSErrorPointer) -> Any?, completion: @escaping (Any?, Error?) -> Void) {
    runTransaction(with: nil, block: updateBlock, completion: completion)
  }

  public func runTransaction(
    with options: TransactionOptions?,
    block updateBlock: @escaping (Transaction, NSErrorPointer) -> Any?,
    completion: @escaping (Any?, Error?) -> Void
  ) {
    let context = TransactionContext(updateBlock: updateBlock)
    let boxed = Unmanaged.passRetained(context as AnyObject)
    let future = swift_firebase.swift_cxx_shims.firebase.firestore.firestore_run_transaction(
      self, options ?? .init(), { transaction, pErrorMessage, pvUpdateBlock in
        let context = Unmanaged<AnyObject>.fromOpaque(pvUpdateBlock!).takeUnretainedValue() as! TransactionContext

        // Instead of trying to relay the generated `NSError` through firebase's `Error` type
        // and error message string, just store the `NSError` on `context` and access it later.
        // We then only need to tell firebase if the update block succeeded or failed and can
        // just not bother setting `pErrorMessage`.

        // It is expected to run `updateBlock` on whatever thread this happens to be. This is
        // consistent with the behavior of the ObjC API as well.

        // Since we could run `updateBlock` multiple times, we need to take care to reset any
        // residue from previous runs. That means clearing out this error field.
        context.error = nil

        context.result = context.updateBlock(transaction!.pointee, &context.error)

        return context.error == nil ? firebase.firestore.kErrorNone : firebase.firestore.kErrorCancelled
      },
      boxed.toOpaque()
    )
    future.setCompletion({
      completion(context.result, context.error)
      boxed.release()
    })
  }

  public func batch() -> WriteBatch {
    swift_firebase.swift_cxx_shims.firebase.firestore.firestore_batch(self)
  }

  private class TransactionContext {
    typealias UpdateBlock = (Transaction, NSErrorPointer) -> Any?

    let updateBlock: UpdateBlock
    var result: Any?
    var error: NSError?

    init(updateBlock: @escaping UpdateBlock) {
      self.updateBlock = updateBlock
    }
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
