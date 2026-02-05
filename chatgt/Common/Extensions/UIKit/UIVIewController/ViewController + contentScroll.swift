//
//  ViewController + contentScroll.swift
//  ExtensionKit
//

import UIKit

public extension UIViewController {
    
    var contentScrollView: UIScrollView? {
        let key = "Y29udGVudFNjcm9sbFZpZXc=".base64Decoded /// contentScrollView
        return value(forKey: key!) as? UIScrollView
    }
    
}
