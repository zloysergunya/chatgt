//
//  KeyPath + operators.swift
//  ExtensionKit
//

import Foundation

public typealias Equation<T, V> = (T) -> V

public extension KeyPath where Value: Numeric {
    // MARK: - Combine keypaths with keypaths
    @inlinable @inline(__always)
    static func + (lhs: KeyPath, rhs: KeyPath) -> Equation<Root, Value> {
        { $0[keyPath: lhs] + $0[keyPath: rhs] }
    }
    
    @inlinable @inline(__always)
    static func - (lhs: KeyPath, rhs: KeyPath) -> Equation<Root, Value> {
        { $0[keyPath: lhs] - $0[keyPath: rhs] }
    }
    
    @inlinable @inline(__always)
    static func * (lhs: KeyPath, rhs: KeyPath) -> Equation<Root, Value> {
        { $0[keyPath: lhs] * $0[keyPath: rhs] }
    }
    
    // MARK: - Combine keypaths with values
    @inlinable @inline(__always)
    static func + (lhs: KeyPath, rhs: Value) -> Equation<Root, Value> {
        { $0[keyPath: lhs] + rhs }
    }
    
    @inlinable @inline(__always)
    static func - (lhs: KeyPath, rhs: Value) -> Equation<Root, Value> {
        { $0[keyPath: lhs] - rhs }
    }
    
    @inlinable @inline(__always)
    static func * (lhs: KeyPath, rhs: Value) -> Equation<Root, Value> {
        { $0[keyPath: lhs] * rhs }
    }
}

public extension KeyPath where Value: FloatingPoint {
    
    // MARK: - Combine keypaths with keypaths
    @inlinable @inline(__always)
    static func / (lhs: KeyPath, rhs: KeyPath) -> Equation<Root, Value> {
        { $0[keyPath: lhs] / $0[keyPath: rhs] }
    }
    
    // MARK: - Combine keypaths with values
    @inlinable @inline(__always)
    static func / (lhs: KeyPath, rhs: Value) -> Equation<Root, Value> {
        { $0[keyPath: lhs] / rhs }
    }
}

// MARK: - Combine Equation with Equation
@inlinable @inline(__always)
public func + <T, V: Numeric>(lhs: @escaping Equation<T, V>, rhs: @escaping Equation<T, V>) -> Equation<T, V> {
    { lhs($0) + rhs($0) }
}

@inlinable @inline(__always)
public func - <T, V: Numeric>(lhs: @escaping Equation<T, V>, rhs: @escaping Equation<T, V>) -> Equation<T, V> {
    { lhs($0) - rhs($0) }
}

@inlinable @inline(__always)
public func * <T, V: Numeric>(lhs: @escaping Equation<T, V>, rhs: @escaping Equation<T, V>) -> Equation<T, V> {
    { lhs($0) * rhs($0) }
}

@inlinable @inline(__always)
public func / <T, V: FloatingPoint>(lhs: @escaping Equation<T, V>, rhs: @escaping Equation<T, V>) -> Equation<T, V> {
    { lhs($0) / rhs($0) }
}

// MARK: - Combine Equation with Equation

@inlinable @inline(__always)
public func + <T, V: Numeric>(lhs: @escaping Equation<T, V>, rhs: V) -> Equation<T, V> {
    { lhs($0) + rhs }
}

@inlinable @inline(__always)
public func - <T, V: Numeric>(lhs: @escaping Equation<T, V>, rhs: V) -> Equation<T, V> {
    { lhs($0) - rhs }
}

@inlinable @inline(__always)
public func * <T, V: Numeric>(lhs: @escaping Equation<T, V>, rhs: V) -> Equation<T, V> {
    { lhs($0) * rhs }
}

@inlinable @inline(__always)
public func / <T, V: FloatingPoint>(lhs: @escaping Equation<T, V>, rhs: V) -> Equation<T, V> {
    { lhs($0) / rhs }
}

// MARK: - Collections
public extension KeyPath where Value: RangeReplaceableCollection {
    @inlinable @inline(__always)
    static func + (lhs: KeyPath, rhs: KeyPath) -> Equation<Root, Value> {
        { $0[keyPath: lhs] + $0[keyPath: rhs] }
    }
    
    @inlinable @inline(__always)
    static func + (lhs: KeyPath, rhs: Value) -> Equation<Root, Value> {
        { $0[keyPath: lhs] + rhs }
    }
}

// MARK: - Optionals
public extension KeyPath {
    @inlinable @inline(__always)
    static func ?? (lhs: KeyPath<Root, Value?>, rhs: Value) -> Equation<Root, Value> {
        { $0[keyPath: lhs] ?? rhs }
    }
    
    @inlinable @inline(__always)
    static func ?? (lhs: KeyPath<Root, Value?>, rhs: Value?) -> Equation<Root, Value?> {
        { $0[keyPath: lhs] ?? rhs }
    }
    
    @inlinable @inline(__always)
    static func ?? (lhs: KeyPath<Root, Value?>, rhs: KeyPath<Root, Value>) -> Equation<Root, Value> {
        { $0[keyPath: lhs] ?? $0[keyPath: rhs] }
    }
    
    @inlinable @inline(__always)
    static func ?? (lhs: KeyPath<Root, Value?>, rhs: KeyPath<Root, Value?>) -> Equation<Root, Value?> {
        { $0[keyPath: lhs] ?? $0[keyPath: rhs] }
    }
}


@inlinable @inline(__always)
public func ?? <T, V>(lhs: @escaping Equation<T, V?>, rhs: V) -> Equation<T, V> {
    { lhs($0) ?? rhs }
}

@inlinable @inline(__always)
public func ?? <T, V>(lhs: @escaping Equation<T, V?>, rhs: V?) -> Equation<T, V?> {
    { lhs($0) ?? rhs }
}
