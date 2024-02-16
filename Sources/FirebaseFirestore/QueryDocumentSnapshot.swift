// SPDX-License-Identifier: BSD-3-Clause

// Wraps a DocumentSnapshot providing a `data(with:)` implementation that
// cannot return `nil`.
public struct QueryDocumentSnapshot {
  private let snapshot: DocumentSnapshot

  internal init(snapshot: DocumentSnapshot) {
    self.snapshot = snapshot
  }

  public var reference: DocumentReference {
    snapshot.reference
  }

  public var exists: Bool {
    snapshot.exists
  }

  public var documentID: String {
    snapshot.documentID
  }

  public func data(with behavior: ServerTimestampBehavior = .default) -> [String : Any] {
    let data = swift_firebase.swift_cxx_shims.firebase.firestore.document_snapshot_get_data_workaround(snapshot, behavior)
    return FirestoreDataConverter.value(workaround: data)
  }
}
