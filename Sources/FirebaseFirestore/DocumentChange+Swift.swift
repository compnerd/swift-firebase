// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import CxxShim

public typealias DocumentChange = firebase.firestore.DocumentChange

public enum DocumentChangeType: Int {
  case added
  case modified
  case removed
}

extension DocumentChange {
  public var type: DocumentChangeType {
    .fromType(swift_firebase.swift_cxx_shims.firebase.firestore.document_change_type(self))
  }

  public var document: QueryDocumentSnapshot {
    .init(snapshot: swift_firebase.swift_cxx_shims.firebase.firestore.document_change_document(self))
  }

  public var oldIndex: UInt {
    UInt(swift_firebase.swift_cxx_shims.firebase.firestore.document_change_old_index(self))
  }

  public var newIndex: UInt {
    UInt(swift_firebase.swift_cxx_shims.firebase.firestore.document_change_new_index(self))
  }
}

private extension DocumentChangeType {
  static func fromType(_ type: firebase.firestore.DocumentChange.`Type`) -> DocumentChangeType {
    .init(rawValue: Int(type.rawValue))!
  }
}
