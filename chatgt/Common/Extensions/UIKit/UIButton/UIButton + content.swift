//
//  UIButton + content.swift
//  ExtensionKit
//

import UIKit

public extension UIButton {
    func setContentEdgeInsetsWithSpacing(insets: UIEdgeInsets, spacing: CGFloat) {
        let insetAmount = spacing / 2
        
        let edgeInset = UIEdgeInsets(
            top: insets.top,
            left: insets.left + insetAmount,
            bottom: insets.bottom,
            right: insets.right + insetAmount
        )
        if contentEdgeInsets != edgeInset {
            self.contentEdgeInsets = edgeInset
        }
        
        if Int(imageEdgeInsets.left) != Int(-insetAmount) {
            imageEdgeInsets.left = -insetAmount
        }
        
        if Int(imageEdgeInsets.right) != Int(insetAmount) {
            imageEdgeInsets.right = insetAmount
        }
        
        if Int(titleEdgeInsets.left) != Int(insetAmount) {
            titleEdgeInsets.left = insetAmount
        }
        
        if Int(titleEdgeInsets.right) != Int(-insetAmount) {
            titleEdgeInsets.right = -insetAmount
        }
    }

    func alignVertical(spacing: CGFloat = 4.0) {
        guard let imageSize = imageView?.image?.size,
              let text = titleLabel?.text,
              let font = titleLabel?.font else { return }
        titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageSize.width,
            bottom: -(imageSize.height + CGFloat(spacing)),
            right: 0.0
        )
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [.font: font])
        imageEdgeInsets = UIEdgeInsets(
            top: -(titleSize.height + CGFloat(spacing)),
            left: 0.0,
            bottom: 0.0,
            right: -titleSize.width
        )
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0 - spacing
        contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }

    func resetVerticalAlignment() {
        titleEdgeInsets = .zero
        imageEdgeInsets = .zero
        contentEdgeInsets = .zero
    }

    func mirroringContetnt(_ mirroring: Bool) {
        transform = CGAffineTransform(scaleX: mirroring ? -1 : 1, y: 1)
        titleLabel?.transform = CGAffineTransform(scaleX: mirroring ? -1 : 1, y: 1)
        imageView?.transform = CGAffineTransform(scaleX: mirroring ? -1 : 1, y: 1)
    }
}
