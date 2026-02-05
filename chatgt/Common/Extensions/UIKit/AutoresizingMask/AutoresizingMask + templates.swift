//
//  AutoresizingMask + templates.swift
//  ExtensionKit
//

import UIKit

public extension UIView.AutoresizingMask {
    static var flexibleSize: UIView.AutoresizingMask {
        [.flexibleWidth, .flexibleHeight]
    }

    static var flexibleMargins: UIView.AutoresizingMask {
        [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
    }
}
