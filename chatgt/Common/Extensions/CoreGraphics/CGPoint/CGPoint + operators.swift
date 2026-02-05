//
//  CGPoint + operators.swift
//  ExtensionKit
//

import CoreGraphics

public extension CGPoint {

    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x * right.x, y: left.y * right.y)
    }
    
    static func / (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x / right.x, y: left.y / right.y)
    }
}

public extension CGPoint {

    static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    
    static func *= (left: inout CGPoint, right: CGPoint) {
        left = left * right
    }
    
    static func /= (left: inout CGPoint, right: CGPoint) {
        left = left / right
    }
    
}
