//
//  NSObject + copy.swift
//  ExtensionKit
//

import Foundation

public extension NSObject {
    func copyObject() -> Self! { copy() as? Self }
}
