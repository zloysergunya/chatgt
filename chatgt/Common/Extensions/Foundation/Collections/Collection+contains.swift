import Foundation

public extension Collection where Element: Hashable {
    func contains(_ element: Element?) -> Bool {
        self.contains(where: { $0 == element })
    }
}
