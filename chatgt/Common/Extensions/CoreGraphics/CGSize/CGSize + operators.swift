//
//  CGSize + operators.swift
//  ExtensionKit
//

import CoreGraphics

public extension CGSize {

    static func + (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    static func - (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    
    static func * (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width * right.width, height: left.height * right.height)
    }
    
    static func / (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width / right.width, height: left.height / right.height)
    }
}

public extension CGSize {

    static func += (left: inout CGSize, right: CGSize) {
        left = left + right
    }
    
    static func -= (left: inout CGSize, right: CGSize) {
        left = left - right
    }
    
    static func *= (left: inout CGSize, right: CGSize) {
        left = left * right
    }
    
    static func /= (left: inout CGSize, right: CGSize) {
        left = left / right
    }
    
}
