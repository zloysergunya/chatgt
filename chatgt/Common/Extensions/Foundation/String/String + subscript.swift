//
//  String + subscript.swift
//  ExtensionKit
//

import Foundation

public extension String {
    subscript (range: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (
            lower: max(0, min(count, range.lowerBound)),
            upper: min(count, max(0, range.upperBound))
        ))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    subscript (index: Int) -> String {
        self[index ..< index + 1]
    }
 
    func last(_ count: Int) -> String {
        if self.count <= count { return self }
        let startIndex = self.count - count
        return String(self[startIndex ..< self.count])
    }
}
