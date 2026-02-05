//
//  CGPoint + pointRelations.swift
//  ExtensionKit
//

import CoreGraphics

public extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
    
    func angle(to point: CGPoint) -> CGFloat {
        atan2(point.y - y, point.x - x)
    }
}
