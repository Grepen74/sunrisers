import Foundation

extension Date {
    static var nextSevenDays: [Date] {
        var days = [Date]()
        var date = Date()
        
        for _ in 0...6 {
            date.addTimeInterval(3600*24)
            days.append(date)
        }
        
        return days
    }
}
