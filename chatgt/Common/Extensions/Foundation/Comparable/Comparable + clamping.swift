//
//  Comparable + clamping.swift
//  ExtensionKit
//

import Foundation

public extension Comparable {
    func clamped(_ minEdge: Self, _ maxEdge: Self) -> Self {
        max(min(self, maxEdge), minEdge)
    }
}
