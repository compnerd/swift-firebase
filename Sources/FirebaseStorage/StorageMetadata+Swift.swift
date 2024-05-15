// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim

public class StorageMetadata {
  let impl: firebase.storage.Metadata

  init(_ impl: firebase.storage.Metadata) {
    self.impl = impl
  }

  public init() {
    self.impl = .init()
  }

  public var customMetadata: [String: String]? {
    get {
      let map = swift_firebase.swift_cxx_shims.firebase.storage.metadata_get_custom_metadata(impl)
      return map.toDict()
    }
    set {
      swift_firebase.swift_cxx_shims.firebase.storage.metadata_clear_custom_metadata(impl)
      guard let newValue else { return }
      for (key, value) in newValue {
        swift_firebase.swift_cxx_shims.firebase.storage.metadata_insert_custom_metadata(
          impl, std.string(key), std.string(value)
        )
      }
    }
  }
}

// Workaround for https://github.com/apple/swift/issues/69711
private extension swift_firebase.swift_cxx_shims.firebase.storage.CustomMetadata {
  borrowing func toDict() -> [String: String] {
    var result = [String: String]()
    var iterator = swift_firebase.swift_cxx_shims.firebase.storage.custom_metadata_begin(self)
    let endIterator = swift_firebase.swift_cxx_shims.firebase.storage.custom_metadata_end(self)

    while !swift_firebase.swift_cxx_shims.firebase.storage.custom_metadata_iterators_equal(iterator, endIterator) {
      let key = swift_firebase.swift_cxx_shims.firebase.storage.custom_metadata_iterator_first(iterator)
      let value = swift_firebase.swift_cxx_shims.firebase.storage.custom_metadata_iterator_second(iterator)
      result[String(key.pointee)] = String(value.pointee)
      iterator = iterator.successor()
    }
    return result
  }
}
