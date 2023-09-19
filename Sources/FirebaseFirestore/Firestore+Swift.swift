// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(Error)
import FirebaseCore

import CxxShim
import Foundation

public typealias Firestore = UnsafeMutablePointer<firebase.firestore.Firestore>

extension Firestore {
  public static func firestore() -> Firestore {
    guard let application = firebase.App.GetInstance() else {
      fatalError("no default application")
    }
    return firestore(app: application)
  }

  public static func firestore(app: FirebaseApp) -> Firestore {
    firebase.firestore.Firestore.GetInstance(app, nil)
  }

  public func document(_ documentPath: String) -> DocumentReference {
    let document = swift_firebase.swift_cxx_shims.firebase.firestore.firestore_document(self.pointee, std.string(documentPath))
    return document
  }
}