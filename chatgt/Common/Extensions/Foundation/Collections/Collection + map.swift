//
//  Collection + map.swift
//  ExtensionKit
//

import Foundation

public extension Sequence {
  
    func compact<T>() -> [T] where Element == T? {
        self.compactMap({ $0 })
    }

    func compactMap<ElementOfResult>(as type: ElementOfResult.Type) -> [ElementOfResult] {
        compactMap({ $0 as? ElementOfResult })
    }
  
}
