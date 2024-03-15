// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public typealias Query = firebase.firestore.Query

// Any types that extend from Query can conform to QueryProtocol to provide the
// functionality of Query. This is needed since structs in Swift do not support
// inheritance and C++ classes are exposed as structs to Swift.
public protocol QueryProtocol {
  // This is an internal means to expose `Query` when the conforming type is
  // intended to be a subclass of `Query`.
  var _asQuery: Query { get }
}

extension Query: QueryProtocol {
  public var _asQuery: Query { self }
}

extension QueryProtocol {
  public var firestore: Firestore {
    .init(swift_firebase.swift_cxx_shims.firebase.firestore.query_firestore(_asQuery))
  }

  // This variant is provided for compatibility with the ObjC API.
  public func getDocuments(source: FirestoreSource = .default, completion: @escaping (QuerySnapshot?, Error?) -> Void) {
    let future = swift_firebase.swift_cxx_shims.firebase.firestore.query_get(_asQuery, source)
    future.setCompletion({
      let (snapshot, error) = future.resultAndError
      DispatchQueue.main.async {
        completion(snapshot, error)
      }
    })
  }

  public func getDocuments(source: FirestoreSource = .default) async throws -> QuerySnapshot {
    try await withCheckedThrowingContinuation { continuation in
      let future = swift_firebase.swift_cxx_shims.firebase.firestore.query_get(_asQuery, source)
      future.setCompletion({
        let (snapshot, error) = future.resultAndError
        if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: snapshot ?? .init())
        }
      })
    }
  }

  public func addSnapshotListener(_ listener: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration {
    addSnapshotListener(includeMetadataChanges: false, listener: listener)
  }

  public func addSnapshotListener(includeMetadataChanges: Bool, listener: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration {
    typealias ListenerCallback = (QuerySnapshot?, Error?) -> Void
    let boxed = Unmanaged.passRetained(listener as AnyObject)
    let instance = swift_firebase.swift_cxx_shims.firebase.firestore.query_add_snapshot_listener(
      includeMetadataChanges,
      _asQuery,
      { snapshot, errorCode, errorMessage, pvListener in
        let callback = Unmanaged<AnyObject>.fromOpaque(pvListener!).takeUnretainedValue() as! ListenerCallback

        let error = FirestoreErrorCode(errorCode, errorMessage: errorMessage)
        // We only return a snapshot if the error code isn't 0 (aka the 'ok' error code)
        let returned = error == nil ? snapshot?.pointee : nil

        // Make sure we dispatch our callback back into the main thread to keep consistent
        // with the reference API which will call back on the 'user_executor' which typically
        // ends up being the main queue.
        // Relevant code:
        // - https://github.com/firebase/firebase-ios-sdk/blob/main/Firestore/Source/API/FIRFirestore.mm#L210-L218
        // - https://github.com/firebase/firebase-ios-sdk/blob/main/Firestore/core/src/api/document_reference.cc#L236-L237
        DispatchQueue.main.async {
          callback(returned, error)
        }
      },
      boxed.toOpaque()
    )
    return ListenerRegistration(boxed, instance)
  }

  private func firestoreValueOrFail(_ value: Any) -> firebase.firestore.FieldValue {
    guard let value = FirestoreDataConverter.firestoreValue(field: value) else {
      fatalError("Unexpected value type: \(type(of: value))")
    }
    return value
  }

  public func whereField(_ field: String, isEqualTo value: Any) -> Query {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_where_equal_to(
      _asQuery, std.string(field), firestoreValueOrFail(value)
    )
  }

  public func whereField(_ field: String, isNotEqualTo value: Any) -> Query {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_where_not_equal_to(
      _asQuery, std.string(field), firestoreValueOrFail(value)
    )
  }

  public func whereField(_ field: String, isLessThan value: Any) -> Query {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_where_less_than(
      _asQuery, std.string(field), firestoreValueOrFail(value)
    )
  }

  public func whereField(_ field: String, isLessThanOrEqualTo value: Any) -> Query {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_where_less_than_or_equal_to(
      _asQuery, std.string(field), firestoreValueOrFail(value)
    )
  }

  public func whereField(_ field: String, isGreaterThan value: Any) -> Query {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_where_greater_than(
      _asQuery, std.string(field), firestoreValueOrFail(value)
    )
  }

  public func whereField(_ field: String, isGreaterThanOrEqualTo value: Any) -> Query {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_where_greater_than_or_equal_to(
      _asQuery, std.string(field), firestoreValueOrFail(value)
    )
  }

  /* TODO: Implement these remaining methods:

  public func whereFilter(_ filter: Filter) -> Query {
  }

  public func whereField(_ field: String, arrayContains value: Any) -> Query {
  }

  public func whereField(_ field: String, arrayContainsAny values: [Any]) -> Query {
  }

  public func whereField(_ field: String, in values: [Any]) -> Query {
  }

  public func whereField(_ field: String, notIn values: [Any]) -> Query {
  }

  public func whereField(_ path: FieldPath, isNotEqualTo value: Any) -> Query {
  }

  public func whereField(_ path: FieldPath, isEqualTo value: Any) -> Query {
  }

  public func whereField(_ path: FieldPath, isLessThan value: Any) -> Query {
  }

  public func whereField(_ path: FieldPath, isLessThanOrEqualTo value: Any) -> Query {
  }

  public func whereField(_ path: FieldPath, isGreaterThan value: Any) -> Query {
  }

  public func whereField(_ path: FieldPath, isGreaterThanOrEqualTo value: Any) -> Query {
  }

  public func whereField(_ path: FieldPath, arrayContains value: Any) -> Query {
  }

  public func whereField(_ path: FieldPath, arrayContainsAny values: [Any]) -> Query {
  }

  public func whereField(_ path: FieldPath, in values: [Any]) -> Query {
  }

  public func whereField(_ path: FieldPath, notIn values: [Any]) -> Query {
  }

  public func filter(using predicate: NSPredicate) -> Query {
  }

  public func order(by field: String) -> Query {
  }

  public func order(by path: FieldPath) -> Query {
  }

  public func order(by field: String, descending: Bool) -> Query {
  }

  public func order(by path: FieldPath, descending: Bool) -> Query {
  }

  public func limit(to limit: Int) -> Query {
  }

  public func limit(toLast limit: Int) -> Query {
  }

  public func start(atDocument document: DocumentSnapshot) -> Query {
  }

  public func start(at fieldValues: [Any]) -> Query {
  }

  public func start(afterDocument document: DocumentSnapshot) -> Query {
  }

  public func start(after fieldValues: [Any]) -> Query {
  }

  public func end(beforeDocument document: DocumentSnapshot) -> Query {
  }

  public func end(before fieldValues: [Any]) -> Query {
  }

  public func end(atDocument document: DocumentSnapshot) -> Query {
  }

  public func end(at fieldValues: [Any]) -> Query {
  }

  public var count: AggregateQuery {
  }

  */
}
