//
//  CGRect + modificatos.swift
//  ExtensionKit
//

import CoreGraphics

public extension CGRect {
    func withX(_ x: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = x
        return rect
    }

    func withY(_ y: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = y
        return rect
    }
    
    func withWidth(_ width: CGFloat) -> CGRect {
        var rect = self
        rect.size.width = width
        return rect
    }

    func withHeight(_ height: CGFloat) -> CGRect {
        var rect = self
        rect.size.height = height
        return rect
    }
    
    func increasingXBy(_ delta: CGFloat) -> CGRect {
        self.withX(self.origin.x + delta)
    }

    func increasingYBy(_ delta: CGFloat) -> CGRect {
        self.withY(self.origin.y + delta)
    }

    func increasingWidthBy(_ delta: CGFloat) -> CGRect {
        self.withWidth(self.width + delta)
    }

    func increasingHeightBy(_ delta: CGFloat) -> CGRect {
        self.withHeight(self.height + delta)
    }
}

public extension CGRect {

    mutating func increaseXBy(_ delta: CGFloat) {
        self = self.increasingXBy(delta)
    }

    mutating func increaseYBy(_ delta: CGFloat) {
        self = self.increasingYBy(delta)
    }

    mutating func increaseWidthBy(_ delta: CGFloat) {
        self = self.increasingWidthBy(delta)
    }

    mutating func increaseHeightBy(_ delta: CGFloat) {
        self = self.increasingHeightBy(delta)
    }
}

public extension CGRect {
    func centeredHorizontallyInRect(_ rect: CGRect) -> CGRect {
        let width = self.width
        return self.withX((rect.width - width) / 2 + rect.origin.x)
    }

    func centeredVerticallyInRect(_ rect: CGRect) -> CGRect {
        let height = self.height
        return self.withY((rect.height - height) / 2 + rect.origin.y)
    }

    func centeredInRect(_ rect: CGRect) -> CGRect {
        self.centeredHorizontallyInRect(rect).centeredVerticallyInRect(rect)
    }
}
