//
//  Array+unique.swift
//  ExtensionKit
//

import Foundation

public extension Array where Element: Hashable {
    func unique() -> Self {
        Array(Set(self))
    }
}

public extension Array {
    func unique<T: Hashable>(by keyTransform: (Element) -> T) -> [Element] {
        var unique = Set<T>(minimumCapacity: count)
        return filter {
            let key = keyTransform($0)
            
            if unique.contains(key) { return false }
            
            unique.insert(key)
            return true
        }
    }
}
