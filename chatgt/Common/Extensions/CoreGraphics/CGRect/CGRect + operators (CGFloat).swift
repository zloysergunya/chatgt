//
//  CGRect + operators (CGFloat).swift
//  ExtensionKit
//

import CoreGraphics

public extension CGRect {

    static func + (left: CGRect, right: CGFloat) -> CGRect {
        CGRect(origin: left.origin + right, size: left.size + right)
    }
    
    static func - (left: CGRect, right: CGFloat) -> CGRect {
        CGRect(origin: left.origin - right, size: left.size - right)
    }
    
    static func * (left: CGRect, right: CGFloat) -> CGRect {
        CGRect(origin: left.origin * right, size: left.size * right)
    }
    
    static func / (left: CGRect, right: CGFloat) -> CGRect {
        CGRect(origin: left.origin / right, size: left.size / right)
    }
}

public extension CGRect {

    static func += (left: inout CGRect, right: CGFloat) {
        left = left + right
    }
    
    static func -= (left: inout CGRect, right: CGFloat) {
        left = left - right
    }
    
    static func *= (left: inout CGRect, right: CGFloat) {
        left = left * right
    }
    
    static func /= (left: inout CGRect, right: CGFloat) {
        left = left / right
    }
    
}
