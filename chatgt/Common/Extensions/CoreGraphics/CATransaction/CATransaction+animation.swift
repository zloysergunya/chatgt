import QuartzCore

public extension CATransaction {
    
    static func performWithoutAnimation(_ f: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        f()
        CATransaction.commit()
    }
}
