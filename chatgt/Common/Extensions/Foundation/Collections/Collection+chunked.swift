//
//  Collection+chunked.swift
//  ExtensionKit
//

import Foundation

public extension Collection where Index == Int {
    func chunked(size: Int) -> [SubSequence] {
        stride(from: startIndex, to: endIndex, by: size).map {
            self[$0 ..< Swift.min($0 + size, count)]
        }
    }
}
