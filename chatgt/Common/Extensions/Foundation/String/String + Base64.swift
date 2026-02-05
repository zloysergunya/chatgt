//
//  String + Base64.swift
//  ExtensionKit
//

import Foundation

public extension StringProtocol {
    
    var base64Encoded: String? { data(using: .utf8)?.base64EncodedString() }

    var base64Decoded: String? {
        if let data = Data(base64Encoded: String(self)) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
}
