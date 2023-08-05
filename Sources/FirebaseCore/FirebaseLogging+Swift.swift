// SPDX-License-Identifier: BSD-3-Clause

import firebase

public typealias FirebaseLoggerLevel = firebase.LogLevel

// Workaround #67604 - Unable to import C++ enumerations
extension firebase.LogLevel {
  public static var kLogLevelVerbose: Self { .init(0) }
  public static var kLogLevelDebug: Self { .init(1) }
  public static var kLogLevelInfo: Self { .init(2) }
  public static var kLogLevelWarning: Self { .init(3) }
  public static var kLogLevelError: Self { .init(4) }
  public static var kLogLevelAssert: Self { .init(5) }
}

extension firebase.LogLevel {
  public static var verbose: Self { kLogLevelVerbose }
  public static var debug: Self { kLogLevelDebug }
  public static var info: Self { kLogLevelInfo }
  public static var warning: Self { kLogLevelWarning }
  public static var error: Self { kLogLevelError }
  public static var assert: Self { kLogLevelAssert }
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
