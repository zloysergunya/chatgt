//
//  UICollectionView + reuse.swift
//  ExtensionKit
//

import UIKit

public extension UICollectionReusableView {
    class var reueseIdentifier: String { "\(Self.self)" }
}

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_ type: T.Type = T.self, identifier: String = T.reueseIdentifier) {
        self.register(type, forCellWithReuseIdentifier: identifier)
    }

    func register<T: UICollectionReusableView>(_ type: T.Type = T.self, identifier: String = T.reueseIdentifier, kind: String) {
        self.register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    func dequeue<T: UICollectionViewCell>(_ type: T.Type = T.self, for indexPath: IndexPath) -> T? {
        self.dequeueReusableCell(withReuseIdentifier: T.reueseIdentifier, for: indexPath) as? T
    }

    func dequeue<T: UICollectionReusableView>(_ type: T.Type = T.self, kind: String, indexPath: IndexPath) -> T? {
        self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reueseIdentifier, for: indexPath) as? T
    }
}

