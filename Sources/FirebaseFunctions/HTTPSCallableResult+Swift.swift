// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public class HTTPSCallableResult {
  let data: Any

  init(_ result: firebase.functions.HttpsCallableResult = .init()) {
    let variant = swift_firebase.swift_cxx_shims.firebase.functions.https_callable_result_data(result)
    let data = try! fromVariant(variant)

    // For compatibility with the ObjC API, map nil to NSNull here.
    self.data = data ?? NSNull()
  }
}
