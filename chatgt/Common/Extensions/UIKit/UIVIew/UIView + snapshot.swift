import UIKit

public extension UIView {
    func imageSnapshot(rendererFormat: UIGraphicsImageRendererFormat = .default()) -> UIImage {
        UIGraphicsImageRenderer(bounds: bounds, format: rendererFormat).image(actions: { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        })
    }
}
