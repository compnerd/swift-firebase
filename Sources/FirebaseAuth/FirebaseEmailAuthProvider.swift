// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public typealias EmailAuthProvider = firebase.auth.EmailAuthProvider
public typealias Credential = firebase.auth.Credential

extension EmailAuthProvider {
    static func credential(withEmail email: String, password: String) -> Credential {
        GetCredential(email, password)
    }
}