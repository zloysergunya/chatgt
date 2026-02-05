//
//  Optional.swift
//  ExtensionKit
//
//

import Foundation

public func > <W: Comparable>(lhs: Optional<W>, rhs: Optional<W>) -> Bool? {
    guard let lhs, let rhs else { return nil }
    return lhs > rhs
}

public func < <W: Comparable>(lhs: Optional<W>, rhs: Optional<W>) -> Bool? {
    guard let lhs, let rhs else { return nil }
    return lhs < rhs
}

public func > <W: Comparable>(lhs: Optional<W>, rhs: W) -> Bool? {
    guard let lhs else { return nil }
    return lhs > rhs
}

public func < <W: Comparable>(lhs: Optional<W>, rhs: W) -> Bool? {
    guard let lhs else { return nil }
    return lhs < rhs
}
