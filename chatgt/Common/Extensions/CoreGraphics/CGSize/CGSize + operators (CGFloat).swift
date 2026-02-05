//
//  CGSize + operators (CGFloat).swift
//  ExtensionKit
//

import CoreGraphics

public extension CGSize {

    static func + (left: CGSize, right: CGFloat) -> CGSize {
        CGSize(width: left.width + right, height: left.height + right)
    }
    
    static func - (left: CGSize, right: CGFloat) -> CGSize {
        CGSize(width: left.width - right, height: left.height - right)
    }
    
    static func * (left: CGSize, right: CGFloat) -> CGSize {
        CGSize(width: left.width * right, height: left.height * right)
    }
    
    static func / (left: CGSize, right: CGFloat) -> CGSize {
        CGSize(width: left.width / right, height: left.height / right)
    }
}

public extension CGSize {

    static func += (left: inout CGSize, right: CGFloat) {
        left = left + right
    }
    
    static func -= (left: inout CGSize, right: CGFloat) {
        left = left - right
    }
    
    static func *= (left: inout CGSize, right: CGFloat) {
        left = left * right
    }
    
    static func /= (left: inout CGSize, right: CGFloat) {
        left = left / right
    }
    
}
