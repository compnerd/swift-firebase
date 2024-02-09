// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import CxxShim

public typealias DocumentChange = firebase.firestore.DocumentChange
public typealias DocumentChangeType = firebase.firestore.DocumentChange.`Type`

extension DocumentChange {
    public var type: DocumentChangeType {
        swift_firebase.swift_cxx_shims.firebase.firestore.document_change_type(self)
    }

    public var document: DocumentSnapshot {
        swift_firebase.swift_cxx_shims.firebase.firestore.document_change_document(self)
    }

    public var oldIndex: UInt {
        UInt(swift_firebase.swift_cxx_shims.firebase.firestore.document_change_old_index(self))
    }

    public var newIndex: UInt {
        UInt(swift_firebase.swift_cxx_shims.firebase.firestore.document_change_new_index(self))
    }
}
