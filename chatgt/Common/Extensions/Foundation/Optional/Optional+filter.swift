import Foundation

public extension Optional {
    func filter(_ closure: (Wrapped) -> Bool) -> Self {
        flatMap({ closure($0) ? $0 : nil })
    }
}
