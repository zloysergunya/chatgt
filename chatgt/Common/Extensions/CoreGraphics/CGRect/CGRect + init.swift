//
//  CGRect + init.swift
//  ExtensionKit
//

import CoreGraphics

public extension CGRect {
    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }

    init(side: CGFloat) {
        self.init(size: CGSize(side: side))
    }

    init(width: CGFloat, height: CGFloat) {
        self.init(size: CGSize(width: width, height: height))
    }
    
    init(center: CGPoint, size: CGSize) {
        self.init(size: size)
        self.origin = .init(x: center.x - size.width / 2, y: center.y - size.height / 2)
    }
}
