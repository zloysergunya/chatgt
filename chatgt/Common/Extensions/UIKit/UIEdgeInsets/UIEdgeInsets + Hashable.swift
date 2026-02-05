//
//  UIEdgeInsets + Hashable.swift
//  ExtensionKit
//

import UIKit

extension UIEdgeInsets: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(top)
        hasher.combine(left)
        hasher.combine(bottom)
        hasher.combine(right)
    }
}

