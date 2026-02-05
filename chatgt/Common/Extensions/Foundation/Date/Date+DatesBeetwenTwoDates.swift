import Foundation

public extension Date {
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var datesArray: [Date] = []
        var currentDate = fromDate
        
        while currentDate <= toDate {
            datesArray.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return datesArray
    }
    
}
