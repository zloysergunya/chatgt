
infix operator ?=

// swiftlint:disable static_operator

/// Optional Assignment Operator.
/// - Parameters:
///   - lhs: mutable value to update
///   - rhs: Optional value
///   writes optional rhs value if it's not nil, if nill, lhs value stays the same
public func ?= <T>(lhs: inout T, rhs: Optional<T>) {
    switch rhs {
    case let .some(value):
        lhs = value
    case .none:
        break
    }
}

// swiftlint:enable static_operator
