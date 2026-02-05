import UIKit

public extension Array where Element: NSAttributedString {
    
    func joined(separator: NSAttributedString) -> NSAttributedString {
        let mutableString = NSMutableAttributedString()
        
        for string in self.dropLast(1) {
            mutableString.append(string)
            mutableString.append(separator)
        }
        
        if let last = self.last {
            mutableString.append(last)
        }
        
        return mutableString
    }
    
    func joined(separator: String = "") -> NSAttributedString {
        joined(separator: NSAttributedString(string: separator))
    }
}
