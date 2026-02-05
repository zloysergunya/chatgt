//
//  UIEdgeInsets + inverted.swift
//  ExtensionKit
//

import UIKit

public extension UIEdgeInsets {
    func inverted() -> UIEdgeInsets {
        UIEdgeInsets(top: -self.top, left: -self.left, bottom: -self.bottom, right: -self.right)
    }
}
