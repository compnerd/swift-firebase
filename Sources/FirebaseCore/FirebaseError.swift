// SPDX-License-Identifier: BSD-3-Clause

public struct FirebaseError: Error {
  public let code: CInt
  public let message: String

  @_spi(Internal)
  public init(code: CInt, message: String) {
    self.code = code
    self.message = message
  }
}
