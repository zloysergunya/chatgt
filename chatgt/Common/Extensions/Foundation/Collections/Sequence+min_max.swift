//
//  Sequence+min_max.swift
//  ExtensionKit
//

import Foundation

public extension Sequence {

    func max<T: Comparable>(by equation: Equation<Element, T>, _ comparator: (T, T) -> Bool) -> Element? {
        self.max(by: {
            comparator(equation($0), equation($1))
        })
    }
    
    func max<T: Comparable>(by equation: Equation<Element, T>) -> Element? {
        self.max(by: equation, <)
    }
    
    func min<T: Comparable>(by equation: Equation<Element, T>, _ comparator: (T, T) -> Bool) -> Element? {
        self.min(by: {
            comparator(equation($0), equation($1))
        })
    }
    
    func min<T: Comparable>(by equation: Equation<Element, T>) -> Element? {
        self.min(by: equation, <)
    }
}
