// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

public typealias FirestoreSource = firebase.firestore.Source

extension FirestoreSource: @unchecked Sendable {}
