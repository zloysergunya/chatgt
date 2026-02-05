import UIKit

public extension UIColor {
    
    convenience init?(red: Int, green: Int, blue: Int) {
        guard
            red >= 0, red <= 255,
            green >= 0, green <= 255,
            blue >= 0, blue <= 255
        else { return nil }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init?(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
    }
    
    convenience init?(hex: String) {
        let hex = hex.filter(\.isHexDigit)
        let scanner = Scanner(string: hex)
        
        var rgbValue: UInt64 = 0
        
        guard scanner.scanHexInt64(&rgbValue) else { return nil }
        
        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF
        
        self.init(
            red: CGFloat(r) / 0xFF,
            green: CGFloat(g) / 0xFF,
            blue: CGFloat(b) / 0xFF, alpha: 1
        )
    }

    var hexString: String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)

        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
}
