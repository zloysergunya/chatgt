import Foundation

public extension Date {
    func add(_ unit: Calendar.Component, value: Int) -> Date? {
        Calendar.current.date(byAdding: unit, value: value, to: self)
    }
}
