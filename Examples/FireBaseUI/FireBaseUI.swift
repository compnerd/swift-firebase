// SPDX-License-Identifier: BSD-3-Clause

import SwiftWin32
import Foundation

import firebase
import FirebaseCore
import FirebaseAuth

extension Foundation.Bundle {
  internal static var resources: URL {
    Bundle.module.bundleURL.appendingPathComponent("Resources")
  }
}

@main
final class FireBaseUI: ApplicationDelegate {
  func application(_ application: Application,
                   didFinishLaunchingWithOptions: [Application.LaunchOptionsKey:Any]?)
      -> Bool {
#if _runtime(_ObjC)
    firebase.App.SetDefaultConfigPath(Bundle.resources.fileSystemRepresentation)
#else
    Bundle.resources.withUnsafeFileSystemRepresentation(firebase.App.SetDefaultConfigPath)
#endif

    FirebaseApp.configure()
    return true
  }
}
