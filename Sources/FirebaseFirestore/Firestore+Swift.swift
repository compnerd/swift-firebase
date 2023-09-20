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
    var result: firebase.InitResult = .init(rawValue: 12)
    guard let instance = firebase.firestore.Firestore.GetInstance(app, &result) else {
      fatalError("Invalid Firestore Instance, \(result)")
    }

    print("Initialized Firestore: \(result)")
    return instance
  }

  public func document(_ documentPath: String) -> DocumentReference {
    let document = swift_firebase.swift_cxx_shims.firebase.firestore.firestore_document(self.pointee, std.string(documentPath))
    print("retreived document: \(document) - \(documentPath)")
    return document
  }

  public func collection(_ collectionPath: String) -> CollectionReference {
    swift_firebase.swift_cxx_shims.firebase.firestore.firestore_collection(self.pointee, std.string(collectionPath))
  }

  public func printSettings() {
    let settings = swift_firebase.swift_cxx_shims.firebase.firestore.firestore_settings(self.pointee)
    print("Firestore Settings: \n \(settings)")
  }
}
