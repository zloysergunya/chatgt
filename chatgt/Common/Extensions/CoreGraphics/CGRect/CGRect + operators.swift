//
//  CGRect + operators.swift
//  ExtensionKit
//

import CoreGraphics

public extension CGRect {

    static func + (left: CGRect, right: CGRect) -> CGRect {
        CGRect(origin: left.origin + right.origin, size: left.size + right.size)
    }
    
    static func - (left: CGRect, right: CGRect) -> CGRect {
        CGRect(origin: left.origin - right.origin, size: left.size - right.size)
    }
    
    static func * (left: CGRect, right: CGRect) -> CGRect {
        CGRect(origin: left.origin * right.origin, size: left.size * right.size)
    }
    
    static func / (left: CGRect, right: CGRect) -> CGRect {
        CGRect(origin: left.origin / right.origin, size: left.size / right.size)
    }
}

public extension CGRect {

    static func += (left: inout CGRect, right: CGRect) {
        left = left + right
    }
    
    static func -= (left: inout CGRect, right: CGRect) {
        left = left - right
    }
    
    static func *= (left: inout CGRect, right: CGRect) {
        left = left * right
    }
    
    static func /= (left: inout CGRect, right: CGRect) {
        left = left / right
    }
    
}
