import UIKit

public extension UIView {
    struct Border {
        public init(width: CGFloat, color: UIColor?) {
            self.width = width
            self.color = color
        }
        
        public var width: CGFloat
        public var color: UIColor?
    }
    
    var border: Border {
        get {
            .init(
                width: layer.borderWidth,
                color: layer.borderColor.map(UIColor.init)
            )
            
        }
        
        set {
            layer.borderColor = newValue.color?.cgColor
            layer.borderWidth = newValue.width
        }
        
    }
}
