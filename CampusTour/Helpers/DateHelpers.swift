import UIKit

class DateHelper {
    static func formatDateRange(startDate start: Date, endDate end: Date) -> String {
        if start.isToday && end.isToday {
            return (start.isNight ? "TONIGHT" : "TODAY") + " " +
                start.string(custom: "HH:mm") + " " +
                end.string(custom: "HH:mm")
        }
        return "\(start.string(custom: "MM-dd"))"
    }
    
    static func getFormattedDate(_ date: Date) -> String {
        if date.isToday && date.isToday {
            return (date.isNight ? "Tonight" : "Today")
        }
        return "\(date.string(custom: "MM-dd"))"
    }
    
    static func getFormattedTime(startTime start: Date, endTime end: Date) -> String {
        let startIsPM = start.hour > 12
        let endIsPM = end.hour > 12
        
        let startFormatted = "\(startIsPM ? start.hour-12 : start.hour):\(start.minute) \(startIsPM ? "PM" : "AM")"
        let endFormatted = "\(endIsPM ? end.hour-12 : end.hour):\(end.minute) \(endIsPM ? "PM" : "AM")"
        
        return "\(startFormatted) - \(endFormatted)"
    }
    
    static func getFormattedMonthAndDay(_ date: Date) -> String {
        return "\(date.monthName) \(date.day)"
    }
}

extension Date {
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone(name: "EST") as TimeZone!
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone(name: "EST") as TimeZone!
        return dateFormatter.date(from: self)!
    }
}
