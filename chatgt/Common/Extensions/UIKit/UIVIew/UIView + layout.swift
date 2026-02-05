//
//  UIView + layout.swift
//  ExtensionKit
//

import UIKit

public extension UIView {
    
    @available(*, deprecated)
    func systemLayoutSizeFittingWidth(_ width: CGFloat) -> CGSize {
        systemLayoutSizeFitting(width: width)
    }
    
    func systemLayoutSizeFitting(width: CGFloat) -> CGSize {
        let fittingSize = CGSize(width: width, height: 0)
        let newSize = self.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return newSize
    }
    
    func systemLayoutSizeFitting(height: CGFloat) -> CGSize {
        let fittingSize = CGSize(width: 0, height: height)
        let newSize = self.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
        return newSize
    }
    
    func frame(in view: UIView) -> CGRect {
        view.convert(self.bounds, from: self)
    }
}
