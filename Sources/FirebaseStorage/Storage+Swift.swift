// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim

public class Storage {
  let impl: swift_firebase.swift_cxx_shims.firebase.storage.StorageRef

  init(_ impl: swift_firebase.swift_cxx_shims.firebase.storage.StorageRef) {
    self.impl = impl
  }

  public static func storage(app: FirebaseApp) -> Storage {
    let instance = swift_firebase.swift_cxx_shims.firebase.storage.storage_get_instance(app)
    guard swift_firebase.swift_cxx_shims.firebase.storage.storage_is_valid(instance) else {
      fatalError("Invalid Storage Instance")
    }
    return .init(instance)
  }

  public func reference(withPath path: String) -> StorageReference {
    .init(swift_firebase.swift_cxx_shims.firebase.storage.storage_get_reference(impl, path))
  }
}
