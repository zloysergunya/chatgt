//
//  UIScrollView + scrollToTop.swift
//  ExtensionKit
//

import UIKit

public extension UIScrollView {
    
    @objc func scrollToTopIfPossible(animated: Bool) {
        
        // _scrollToTopIfPossible:
        let selector = NSSelectorFromString("X3Njcm9sbFRvVG9wSWZQb3NzaWJsZToK".base64Decoded!)
        
        if responds(to: selector) {
            perform(selector, with: ObjCBool(animated))
        } else {
            scrollToTop(animated: animated)
        }
    }
    
    private func scrollToTop(animated: Bool) {
        self.setContentOffset(CGPoint(x: contentOffset.x, y: -contentInset.top), animated: animated)
    }
    
}
