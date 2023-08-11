// SPDX-License-Identifier: BSD-3-Clause

import firebase

public typealias FirebaseLoggerLevel = firebase.LogLevel

extension firebase.LogLevel {
  public static var verbose: Self { firebase.kLogLevelVerbose }
  public static var debug: Self { firebase.kLogLevelDebug }
  public static var info: Self { firebase.kLogLevelInfo }
  public static var warning: Self { firebase.kLogLevelWarning }
  public static var error: Self { firebase.kLogLevelError }
  public static var assert: Self { firebase.kLogLevelAssert }
}

extension firebase.LogLevel {
  public static var min: Self { .error }
  public static var max: Self { .debug }
}

extension firebase.LogLevel: CustomStringConvertible {
  public var description: String {
    switch self {
    case .verbose: return "Verbose"
    case .debug: return "Debug"
    case .info: return "Info"
    case .warning: return "Warning"
    case .error: return "Error"
    case .assert: return "Assert"
    default: fatalError("unknown value for firebase.LogLevel")
    }
  }
}
