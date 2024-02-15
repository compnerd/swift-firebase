// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

public typealias SnapshotMetadata = firebase.firestore.SnapshotMetadata

extension SnapshotMetadata {
  public var hasPendingWrites: Bool {
    has_pending_writes()
  }

  public var isFromCache: Bool {
    is_from_cache()
  }
}
