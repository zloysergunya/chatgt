//
//  String + regex.swift
//  ExtensionKit
//

import Foundation

public extension String {
    func replaceMatches(pattern: String, withString replacementString: String) -> String {
        let string = self
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSMakeRange(0, string.count)
            return regex.stringByReplacingMatches(in: string, range: range, withTemplate: replacementString)
        } catch {
            return self
        }
    }
}
