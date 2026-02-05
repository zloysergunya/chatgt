//
//  Optional.swift
//  ExtensionKit
//
//

import Foundation

extension Optional: CaseIterable where Wrapped: CaseIterable {
    public static var allCases: [Optional<Wrapped>] {
        Wrapped.allCases.map({ Optional<Wrapped>.some($0) }) + [.none]
    }
}
