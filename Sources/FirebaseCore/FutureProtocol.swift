@_exported
import firebase

@_spi(Internal)
public protocol FutureProtocol {
  //associatedtype ResultType
  //associatedtype CompletionType
  //func CallOnCompletion(_ c: CompletionType)

  func Foo()

  //func CallOnCompletion(_ completion: @escaping (UnsafeMutableRawPointer) -> Void, _ userData: UnsafeMutableRawPointer)
  func CallOnCompletion(_ c: UnsafeMutableRawPointer)
}

@_spi(Internal)
public extension FutureProtocol {
  /*
  func setCompletion(_ completion: @escaping (ResultType?, Error?) -> Void) {
    withUnsafePointer(to: completion) { completion in
      setOnCompletion({ future, pvCompletion in
        // XXX
      }, UnsafeMutableRawPointer(mutating: completion))
    }
  }
  */

  func setCompletion(_ completion: @escaping () -> Void) {
    Foo()

    /*
    withUnsafePointer(to: completion) { completion in
      CallOnCompletion({ pvCompletion in
        // XXX
      }, UnsafeMutableRawPointer(mutating: completion))
    }
    */
  }
}
