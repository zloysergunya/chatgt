//
//  Sequence + async.swift
//  ExtensionKit
//

import Foundation

public extension Sequence {
    func mapAsync<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var newState: [T] = []
        for item in self {
            try await newState.append(transform(item))
        }
        return newState
    }
    
    func compactMapAsync<ElementOfResult>(_ transform: (Element) async throws -> ElementOfResult?) async rethrows -> [ElementOfResult] {
        var newState: [ElementOfResult] = []
        for item in self {
            if let result = try await transform(item) {
                newState.append(result)
            }
        }
        return newState
    }
    
    func flatMapAsync<SegmentOfResult>(_ transform: (Element) async throws -> SegmentOfResult) async rethrows -> [SegmentOfResult.Element] where SegmentOfResult: Sequence {
        var newState: [SegmentOfResult.Element] = []
        for item in self {
            newState += try await transform(item)
        }
        return newState
    }
}
