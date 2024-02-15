// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import CxxShim

public typealias QuerySnapshot = firebase.firestore.QuerySnapshot

extension QuerySnapshot {
  public var query: Query {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_snapshot_query(self)
  }

  public var metadata: SnapshotMetadata {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_snapshot_metadata(self)
  }

  public var isEmpty: Bool {
    empty()
  }

  public var count: Int {
    swift_firebase.swift_cxx_shims.firebase.firestore.query_snapshot_size(self)
  }

  public var documents: [DocumentSnapshot] {
    Array<DocumentSnapshot>(swift_firebase.swift_cxx_shims.firebase.firestore.query_snapshot_documents(self))
  }

  public var documentChanges: [DocumentChange] {
    Array<DocumentChange>(
      swift_firebase.swift_cxx_shims.firebase.firestore.query_snapshot_document_changes(self, .exclude)
    )
  }

  public func documentChanges(includeMetadataChanges: Bool) -> [DocumentChange] {
    Array<DocumentChange>(
      swift_firebase.swift_cxx_shims.firebase.firestore.query_snapshot_document_changes(self, includeMetadataChanges ? .include : .exclude)
    )
  }
}
