//
//  UIImage + view.swift
//  ExtensionKit
//

import UIKit

public extension UIImage {
    convenience init?(view: UIView) {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
        guard let cgImage = image.cgImage else { return nil }
        
        self.init(cgImage: cgImage, scale: view.contentScaleFactor, orientation: .up)
    }
}
