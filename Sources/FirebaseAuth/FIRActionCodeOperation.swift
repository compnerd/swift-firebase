// SPDX-License-Identifier: BSD-3-Clause

public enum ActionCodeOperation: Int {
  case unknown
  case passwordReset
  case verifyEmail
  case recoverEmail
  case emailLink
  case verifyAndChangeEmail
  case revertSecondFactorAddition
}
