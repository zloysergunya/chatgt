//
//  CGPoint + operators (CGFloat).swift
//  ExtensionKit
//

import CoreGraphics

public extension CGPoint {

    static func + (left: CGPoint, right: CGFloat) -> CGPoint {
        CGPoint(x: left.x + right, y: left.y + right)
    }
    
    static func - (left: CGPoint, right: CGFloat) -> CGPoint {
        CGPoint(x: left.x - right, y: left.y - right)
    }
    
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        CGPoint(x: left.x * right, y: left.y * right)
    }
    
    static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        CGPoint(x: left.x / right, y: left.y / right)
    }
}

public extension CGPoint {

    static func += (left: inout CGPoint, right: CGFloat) {
        left = left + right
    }
    
    static func -= (left: inout CGPoint, right: CGFloat) {
        left = left - right
    }
    
    static func *= (left: inout CGPoint, right: CGFloat) {
        left = left * right
    }
    
    static func /= (left: inout CGPoint, right: CGFloat) {
        left = left / right
    }
    
}
