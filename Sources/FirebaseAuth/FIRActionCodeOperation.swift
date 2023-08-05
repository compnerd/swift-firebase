// SPDX-License-Identifier: BSD-3-Clause

public enum ActionCodeOperation: Int {
  case FIRActionCodeOperationUnknown
  case FIRActionCodeOperationPasswordReset
  case FIRActionCodeOperationVerifyEmail
  case FIRActionCodeOperationRecoverEmail
  case FIRActionCodeOperationEmailLink
  case FIRActionCodeOperationVerifyAndChangeEmail
  case FIRActionCodeOperationRevertSecondFactorAddition
}
