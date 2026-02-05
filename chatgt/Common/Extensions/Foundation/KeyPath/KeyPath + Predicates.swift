//
//  KeyPath.swift
//  ExtensionKit
//

import Foundation

public typealias Predicate<T> = Equation<T, Bool>

public extension KeyPath where Value: Equatable {
    // MARK: - Combine keypaths with keypath
    @inlinable @inline(__always)
    static func == (lhs: KeyPath, rhs: KeyPath) -> Predicate<Root> {
        { $0[keyPath: lhs] == $0[keyPath: rhs] }
    }
    
    @inlinable @inline(__always)
    static func != (lhs: KeyPath, rhs: KeyPath) -> Predicate<Root> {
        { $0[keyPath: lhs] != $0[keyPath: rhs] }
    }
    
    @inlinable @inline(__always)
    static func == (lhs: KeyPath, rhs: KeyPath<Root, Value?>) -> Predicate<Root> {
        { $0[keyPath: lhs] == $0[keyPath: rhs] }
    }
    
    @inlinable @inline(__always)
    static func != (lhs: KeyPath, rhs: KeyPath<Root, Value?>) -> Predicate<Root> {
        { $0[keyPath: lhs] != $0[keyPath: rhs] }
    }
    
    // MARK: - Combine keypaths with values
    @inlinable @inline(__always)
    static func == (lhs: KeyPath, rhs: Value) -> Predicate<Root> {
        { $0[keyPath: lhs] == rhs }
    }
    
    @inlinable @inline(__always)
    static func != (lhs: KeyPath, rhs: Value) -> Predicate<Root> {
        { $0[keyPath: lhs] != rhs }
    }
    
    // MARK: - Combine keypaths with optionals
    @inlinable @inline(__always)
    static func == (lhs: KeyPath, rhs: Value?) -> Predicate<Root> {
        { $0[keyPath: lhs] == rhs }
    }
    
    @inlinable @inline(__always)
    static func != (lhs: KeyPath, rhs: Value?) -> Predicate<Root> {
        { $0[keyPath: lhs] != rhs }
    }
    
    @inlinable @inline(__always)
    static func == (lhs: KeyPath<Root, Value?>, rhs: Value) -> Predicate<Root> {
        { $0[keyPath: lhs] == rhs }
    }
    
    @inlinable @inline(__always)
    static func != (lhs: KeyPath<Root, Value?>, rhs: Value) -> Predicate<Root> {
        { $0[keyPath: lhs] != rhs }
    }
}

// MARK: - Combine keypaths with nil
public extension KeyPath {
    
    @inlinable @inline(__always)
    static func == (lhs: KeyPath<Root, Value?>, rhs: _OptionalNilComparisonType) -> Predicate<Root> {
        { $0[keyPath: lhs] == rhs }
    }
    
    @inlinable @inline(__always)
    static func != (lhs: KeyPath<Root, Value?>, rhs: _OptionalNilComparisonType) -> Predicate<Root> {
        { $0[keyPath: lhs] != rhs }
    }
}

public extension KeyPath where Value: AnyObject {
    // MARK: - Combine keypaths with objects
    @inlinable @inline(__always)
    static func === (lhs: KeyPath, rhs: Value) -> Predicate<Root> {
        { $0[keyPath: lhs] === rhs }
    }
    
    @inlinable @inline(__always)
    static func !== (lhs: KeyPath, rhs: Value) -> Predicate<Root> {
        { $0[keyPath: lhs] !== rhs }
    }
    
}

public extension KeyPath where Value: Comparable {
    // MARK: - Combine keypaths with keypath
    @inlinable @inline(__always)
    static func > (lhs: KeyPath, rhs: KeyPath) -> Predicate<Root> {
        { $0[keyPath: lhs] > $0[keyPath: rhs] }
    }
    
    @inlinable @inline(__always)
    static func < (lhs: KeyPath, rhs: KeyPath) -> Predicate<Root> {
        { $0[keyPath: lhs] < $0[keyPath: rhs] }
    }
    
    // MARK: - Combine keypaths with values
    
    @inlinable @inline(__always)
    static func > <T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
        { $0[keyPath: lhs] > rhs }
    }
    
    @inlinable @inline(__always)
    static func < <T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
        { $0[keyPath: lhs] < rhs }
    }
}

public extension KeyPath where Value == Bool {
    // MARK: - Combine keypaths with keypaths
    @inlinable @inline(__always)
    static prefix func ! (keyPath: KeyPath<Root, Value>) -> Predicate<Root> {
        { !$0[keyPath: keyPath] }
    }
    
    // MARK: - Combine Predicates with keypaths
    @inlinable @inline(__always)
    static func && (lhs: @escaping Predicate<Root>, rhs: KeyPath<Root, Value>) -> Predicate<Root> {
        { lhs($0) && $0[keyPath: rhs] }
    }
    
    @inlinable @inline(__always)
    static func || (lhs: @escaping Predicate<Root>, rhs: KeyPath<Root, Value>) -> Predicate<Root> {
        { lhs($0) || $0[keyPath: rhs] }
    }
}

// MARK: - Combine Predicates with Predicates
@inlinable @inline(__always)
public prefix func ! <T>(predicate: @escaping Predicate<T>) -> Predicate<T> {
    { !predicate($0) }
}

@inlinable @inline(__always)
public func && <T>(lhs: @escaping Predicate<T>, rhs: @escaping Predicate<T>) -> Predicate<T> {
    { lhs($0) && rhs($0) }
}

@inlinable @inline(__always)
public func || <T>(lhs: @escaping Predicate<T>, rhs: @escaping Predicate<T>) -> Predicate<T> {
    { lhs($0) || rhs($0) }
}
