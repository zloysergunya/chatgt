//
//  String + URL.swift
//  ExtensionKit
//

import Foundation

public extension String {
    var asURL: URL? { URL(string: self) }
}

public extension Optional where Wrapped == String {
    var asURL: URL? { flatMap(\.asURL) }
}
