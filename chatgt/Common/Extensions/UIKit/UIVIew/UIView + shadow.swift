import UIKit

public extension UIView {
    
    struct Shadow {
        public init(color: UIColor, offset: CGPoint, radius: CGFloat) {
            self.color = color
            self.offset = offset
            self.radius = radius
        }
        
        public var color: UIColor
        public var offset: CGPoint
        public var radius: CGFloat
    }

    
    var shadow: Shadow? {
        get {
            Shadow(
                color: layer.shadowColor.map(UIColor.init) ?? .clear,
                offset: CGPoint(
                    x: layer.shadowOffset.width,
                    y: layer.shadowOffset.height
                ),
                radius: layer.shadowRadius
            )
        }
        set {
            layer.shadowOpacity = newValue == nil ? 0 : 1
            layer.shadowRadius = newValue?.radius ?? 0
            layer.shadowColor = newValue?.color.cgColor
            layer.shadowOffset = .init(
                width: newValue?.offset.x ?? 0,
                height: newValue?.offset.y ?? 0
            )
        }
    }
}
