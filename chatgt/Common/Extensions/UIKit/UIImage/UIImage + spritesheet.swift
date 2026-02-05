import UIKit

public extension UIImage {
    /// Creates an animated image from this spritesheet
    /// - Parameters:
    ///   - frames: Total number of frames in the spritesheet
    ///   - framesPerRow: Number of frames in each row
    ///   - duration: Animation duration in seconds
    /// - Returns: Animated UIImage or nil if creation fails
    func spritesheetAnimation(
        frames: Int,
        framesPerRow: Int,
        duration: TimeInterval,
        redrawContent: Bool = false
    ) -> UIImage? {
        
        let frameImages = spriteSquence(
            framesPerRow: framesPerRow,
            framesCount: frames,
            redrawContent: redrawContent
        )
        
        guard !frameImages.isEmpty else { return nil }
        
        return UIImage.animatedImage(with: frameImages, duration: duration)
    }
    
    func spriteSquence(
        framesPerRow: Int,
        framesCount: Int,
        redrawContent: Bool = false
    ) -> [UIImage] {
        guard let cgImage else { return [] }
        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)
        
        let frameWidth = imageWidth / CGFloat(framesPerRow)
        let rows = (framesCount + framesPerRow - 1) / framesPerRow
        let frameHeight = imageHeight / CGFloat(rows)
        
        var frames: [UIImage] = []
        frames.reserveCapacity(framesCount)
        
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let size = CGSize(width: frameWidth, height: frameHeight)
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        
        for i in 0 ..< framesCount {
            let frameX = i % framesPerRow
            let frameY = i / framesPerRow
            
            let rect = CGRect(
                x: CGFloat(frameX) * frameWidth,
                y: CGFloat(frameY) * frameHeight,
                width: frameWidth,
                height: frameHeight
            )
            
            if let croppedCGImage = cgImage.cropping(to: rect) {
                if redrawContent {
                    frames.append(renderer.image(actions: { ctx in
                        ctx.cgContext.translateBy(x: 0, y: size.height)
                        ctx.cgContext.scaleBy(x: 1, y: -1)
                        ctx.cgContext.draw(croppedCGImage, in: CGRect(origin: .zero, size: size))
                    }))
                } else {
                    frames.append(UIImage(
                        cgImage: croppedCGImage,
                        scale: scale,
                        orientation: imageOrientation
                    ))
                }
                
                
            }
        }
        
        return frames
    }
}

