// SPDX-License-Identifier: BSD-3-Clause
import Foundation
#if os(Windows)
import WinSDK
import CRT
#endif

public typealias Timestamp = firebase.Timestamp
private let NanoSecondsPerSecond = 1_000_000_000

extension Timestamp {
  public init(date: Date) {
    self = date.firestoreTimestamp()
  }

  public init(seconds: Int64, nanoseconds: Int32) {
    self = Timestamp(seconds, nanoseconds)
  }

  public func dateValue() -> Date {
    let seconds = TimeInterval(self.seconds())
    let nanoseconds = TimeInterval(self.nanoseconds())

    let interval = TimeInterval(seconds + nanoseconds / 1e9)

    return Date(timeIntervalSince1970: interval)
  }
}

extension Timestamp: Codable {
  private enum CodingKeys: String, CodingKey {
    case seconds
    case nanoseconds
  }

   public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let seconds = try container.decode(Int64.self, forKey: .seconds)
    let nanoseconds = try container.decode(Int32.self, forKey: .nanoseconds)
    self.init(seconds: seconds, nanoseconds: nanoseconds)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(seconds(), forKey: .seconds)
    try container.encode(nanoseconds(), forKey: .nanoseconds)
  }
}

extension Date {
  internal func firestoreTimestamp() -> Timestamp {
    var (secondsDouble, fraction) = modf(timeIntervalSince1970)

    // Re-implementation of https://github.com/firebase/firebase-ios-sdk/blob/master/Firestore/Source/API/FIRTimestamp.m#L50
    if (fraction < 0) {
      fraction += 1.0;
      secondsDouble -= 1.0;
    }

    let seconds = Int64(secondsDouble)
    let nanoseconds = Int32(fraction * Double(NanoSecondsPerSecond))

    return Timestamp(seconds, nanoseconds)
  }
}
