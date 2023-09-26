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

extension Rect {
  static var zero: Rect = .init(x: 0, y: 0, width: 0, height: 0)

  var maxY: Double {
    origin.y + size.height
  }

  var minY: Double {
    origin.y
  }

  var minX: Double {
    origin.x
  }

  var maxX: Double {
    origin.x + size.width
  }
}
