//
//  UIButton + empty.swift
//  ExtensionKit
//

import UIKit

public extension UIButton {
    var isEmpty: Bool {
        currentImage == nil && currentTitle?.isEmpty ?? true && currentAttributedTitle?.string.isEmpty ?? true
    }
}
