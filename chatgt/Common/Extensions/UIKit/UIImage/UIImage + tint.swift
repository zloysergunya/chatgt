//
//  UIImage + tint.swift
//  ExtensionKit
//

import UIKit

public extension UIImage {
    func template() -> UIImage {
        withRenderingMode(.alwaysTemplate)
    }
    
    func original() -> UIImage {
        withRenderingMode(.alwaysOriginal)
    }
    
    func imageWithAlpha(alpha: CGFloat) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let image = renderer.image { _ in
            draw(at: .zero, blendMode: .normal, alpha: alpha)
        }
        return image
    }
}
