//
//  UIScrollView + pages.swift
//  ExtensionKit
//

import UIKit

public extension UIScrollView {
    var numberOfPages: Int {
        max(Int(self.contentSize.width / self.bounds.width), 1)
    }
    
    var page: Int {
        get {
            let page = (contentOffset.x / bounds.width).rounded()
            if page.isFinite, page != .nan {
                return Int(page).clamped(0, numberOfPages)
            } else {
                return 0
            }
        }
        set {
            contentOffset.x = bounds.width * CGFloat(newValue)
        }
    }
}
