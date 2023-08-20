// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

public class FirebaseConfiguration {
  public static let shared: FirebaseConfiguration = FirebaseConfiguration()

  public func setLoggerLevel(_ loggerLevel: FirebaseLoggerLevel) {
    firebase.SetLogLevel(loggerLevel)
  }
}
