//
//  Sequence+min_max.swift
//  ExtensionKit
//

import Foundation

public extension SetAlgebra {
    func intersects(_ other: Self) -> Bool {
        !self.intersection(other).isEmpty
    }
}
