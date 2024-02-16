// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

private typealias MapFieldValue = firebase.firestore.MapFieldValue

// Expose these types as public to better match the types available from the Cocoa SDK.
public typealias DocumentSnapshot = firebase.firestore.DocumentSnapshot
public typealias ServerTimestampBehavior = firebase.firestore.DocumentSnapshot.ServerTimestampBehavior
public typealias GeoPoint = firebase.firestore.GeoPoint

extension DocumentSnapshot {
  public var reference: DocumentReference {
    swift_firebase.swift_cxx_shims.firebase.firestore.document_snapshot_reference(self)
  }

  public var exists: Bool {
    swift_firebase.swift_cxx_shims.firebase.firestore.document_snapshot_exists(self)
  }

  public var documentID: String {
    String(swift_firebase.swift_cxx_shims.firebase.firestore.document_snapshot_id(self).pointee)
  }

  public func data(with behavior: ServerTimestampBehavior = .default) -> [String: Any]? {
    guard exists else { return nil }
    let data = swift_firebase.swift_cxx_shims.firebase.firestore.document_snapshot_get_data_workaround(self, behavior)
    return FirestoreDataConverter.value(workaround: data)
  }
}

extension DocumentSnapshot {
  public func data<T: Decodable>(as type: T.Type,
                                 with serverTimestampBehavior: ServerTimestampBehavior = .none,
                                 decoder: Firestore.Decoder =  .init()) throws -> T {
    let value: Any = data(with: serverTimestampBehavior) ?? NSNull()
    let result = try decoder.decode(T.self, from: value, in: reference)
    return result
  }
}

extension DocumentSnapshot: CustomDebugStringConvertible {
  public var debugDescription: String {
    String(self.ToString())
  }
}
