// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

import CxxShim
import Foundation

internal enum FutureSupport {
  static let workQueue = DispatchQueue(label: "firebase.firestore.workqueue")

  static func runWork(_ work: @escaping () -> Bool, completion: @escaping (Bool) -> Void) {
    Self.workQueue.async {
      let result = work()
      DispatchQueue.main.async {
        completion(result)
      }
    }
  }

  /*
  static func wait<FutureType>(future: FutureType, timeoutMilliseconds: Int32, completion: @escaping (Bool) -> Void) {
    runWork({
      swift_firebase.swift_cxx_shims.firebase.future_wait(future, timeoutMilliseconds)
    }, completion: completion)
  }
  */
}

/*
public protocol FutureProtocol {
  func Wait(_ timeout_milliseconds: Int32) -> Bool
}

public extension FutureProtocol {
  func wait(
    timeoutMilliseconds: Int32 = firebase.FutureBase.kWaitTimeoutInfinite,
    completion: @escaping (Bool) -> Void
  ) {
    FutureSupport.workQueue.async { [self] in
      let result = Wait(timeoutMilliseconds)
      DispatchQueue.main.async {
        completion(result)
      }
    }
  }
}
*/
