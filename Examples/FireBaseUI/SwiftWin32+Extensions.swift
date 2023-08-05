// SPDX-License-Identifier: BSD-3-Clause

import SwiftWin32

extension Button {
  internal convenience init(frame: Rect, title: String) {
    self.init(frame: frame)
    self.setTitle(title, forState: .normal)
  }
}

extension Label {
  internal convenience init(frame: Rect, title: String) {
    self.init(frame: frame)
    self.text = title
  }
}

extension Switch {
  internal convenience init(frame: Rect, title: String) {
    self.init(frame: frame)
    self.title = title
  }
}
