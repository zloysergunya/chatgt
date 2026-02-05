import UIKit

public extension NSLayoutConstraint {
    @discardableResult
    func activated() -> Self {
        NSLayoutConstraint.activate([self])
        
        return self
    }
}
