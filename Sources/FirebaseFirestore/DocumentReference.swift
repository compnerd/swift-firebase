@_exported
import firebase

import CxxShim
import Foundation

public typealias DocumentReference = firebase.firestore.DocumentReference

extension DocumentReference {
  public var firestore: Firestore {
    return swift_firebase.swift_cxx_shims.firebase.firestore.document_firestore(self)!
  }

  public var path: String {
    return String(swift_firebase.swift_cxx_shims.firebase.firestore.document_path(self))
  }
}
