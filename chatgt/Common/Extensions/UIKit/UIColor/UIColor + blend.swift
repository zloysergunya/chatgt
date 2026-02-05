//
//  File.swift
//  BonMot
//

import UIKit

public extension UIColor {
    static func blend(color1: UIColor, proportion: CGFloat, color2: UIColor) -> UIColor {
        
        guard proportion > 0 else { return color1 }
        guard proportion < 1 else { return color2 }
        
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let l1 = proportion
        let l2 = 1 - proportion

        return UIColor(
            red: l1 * r1 + l2 * r2,
            green: l1 * g1 + l2 * g2,
            blue: l1 * b1 + l2 * b2,
            alpha: l1 * a1 + l2 * a2
        )
    }
    
    func blend(with propotion: CGFloat, color: UIColor) -> UIColor {
        UIColor.blend(color1: self, proportion: propotion, color2: color)
    }
}
