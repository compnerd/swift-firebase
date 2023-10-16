// SPDX-License-Identifier: BSD-3-Clause

import SwiftWin32
import Foundation

import FirebaseCore
import FirebaseAuth

extension Foundation.Bundle {
  internal static var resources: URL {
#if SWIFT_PACKAGE
    Bundle.module.bundleURL.appendingPathComponent("Resources")
#else
    Bundle.main.bundleURL.appendingPathComponent("Resources")
#endif
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

    let path = Bundle.resources.appendingPathComponent("google-services.json")
    guard let options = FirebaseOptions(_contentsOfFile: path, format: .json) else {
      fatalError("Unable to create options from JSON file!")
    }

    FirebaseApp.configure(options: options)
    return true
  }
}
