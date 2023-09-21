// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import CxxShim
import Foundation

public typealias CollectionReference = firebase.firestore.CollectionReference

extension CollectionReference {
  public func document(_ path: String) -> DocumentReference {
    swift_firebase.swift_cxx_shims.firebase.firestore.collection_document(self, std.string(path))
  }
}