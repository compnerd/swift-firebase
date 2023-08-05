// SPDX-License-Identifier: BSD-3-Clause

import SwiftWin32

final class SceneDelegate: WindowSceneDelegate {
  var window: Window?

  func scene(_ scene: Scene, willConnectTo session: SceneSession,
             options: Scene.ConnectionOptions) {
    guard let windowScene = scene as? WindowScene else { return }

    self.window = Window(windowScene: windowScene)
    self.window?.rootViewController = FireBaseUIViewController()
    self.window?.makeKeyAndVisible()
  }
}
