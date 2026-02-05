//
//  CGPoint + init.swift
//  ExtensionKit
//

import CoreGraphics

public extension CGPoint {
    init(_ size: CGSize) {
        self.init(x: size.width, y: size.height)
    }
    
    init(distance: CGFloat, angle: CGFloat) {
        self.init(x: distance * cos(angle), y: distance * sin(angle))
    }
}
