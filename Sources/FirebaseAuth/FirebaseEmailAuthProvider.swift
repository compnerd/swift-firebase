// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase
@_spi(FirebaseInternal)
import FirebaseCore

import CxxShim
import Foundation

public typealias EmailAuthProvider = UnsafeMutablePointer<firebase.auth.EmailAuthProvider>
public typealias Credential = UnsafeMutablePointer<firebase.auth.Credential>

extension EmailAuthProvider {
    func credential(withEmail email: String, password: String) -> Credential {
        GetCredential(email, password)
    }
}