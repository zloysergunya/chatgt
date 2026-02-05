//
//  CGRect + Corners.swift
//  ExtensionKit
//
//  Created by Кирилл on 22.12.2021.
//

import CoreGraphics

public extension CGRect {
    
    var topLeft: CGPoint { origin }
    
    var topRight: CGPoint { .init(x: origin.x + width, y: origin.y) }
    
    var bottomLeft: CGPoint { .init(x: origin.x, y: origin.y + height) }
    
    var bottomRight: CGPoint { .init(x: origin.x + width, y: origin.y + height) }
    
    var center: CGPoint { .init(x: midX, y: midY) }
}
