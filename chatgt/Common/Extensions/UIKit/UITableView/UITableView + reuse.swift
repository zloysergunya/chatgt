//
//  UITableView + dequeue.swift
//  ExtensionKit
//

import UIKit

public extension UITableViewCell {
    class var reueseIdentifier: String { "\(Self.self)" }
}

public extension UITableViewHeaderFooterView {
    class var reueseIdentifier: String { "\(Self.self)" }
}

public extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type = T.self, identifier: String = T.reueseIdentifier) {
        self.register(type, forCellReuseIdentifier: identifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_ type: T.Type = T.self, identifier: String = T.reueseIdentifier) {
        self.register(type, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeue<T: UITableViewCell>(_ type: T.Type = T.self, for indexPath: IndexPath) -> T? {
        self.dequeueReusableCell(withIdentifier: T.reueseIdentifier, for: indexPath) as? T
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(_ type: T.Type = T.self) -> T? {
        self.dequeueReusableHeaderFooterView(withIdentifier: T.reueseIdentifier) as? T
    }
    
    func cellForRow<T>(_ type: T.Type = T.self, at indexPath: IndexPath) -> T? {
        self.cellForRow(at: indexPath) as? T
    }
}
