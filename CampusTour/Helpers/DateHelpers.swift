import UIKit
import SwiftDate

class DateHelper {
    static func getDate(date: Date) -> String {
        return "\(date.dayOfWeekStr), \(date.monthStr) \(date.dayStr)"
    }
    
    static func getTime(date: Date) -> String {
        let ithacaDate = date.inRegion(
            region: Region(
                tz: TimeZone(identifier: "America/New_York")!,
                loc: Locale.current))
        return ithacaDate.string(custom: "hh:mm a")
    }
    
    // Assuming here that events don't span over multiple days
    static func getLongDate(startDate start: Date, endDate end: Date) -> String {
        let date = getFormattedDate(start)
        let startTime = getTime(date: start)
        let endTime = getTime(date: end)
        
        return "\(date) • \(startTime) – \(endTime)".uppercased()
    }
    
    static func getFormattedDate(_ date: Date) -> String {
        if date.isToday {
            return (date.isNight ? "Tonight" : "Today")
        }
        return getDate(date: date)
    }

    static func getStartEndTime(startTime start: Date, endTime end: Date) -> String {
        let startTime = getTime(date: start)
        let endTime = getTime(date: end)
        
        return "\(startTime) - \(endTime)"
    }
    
    static func getFormattedMonthAndDay(_ date: Date) -> String {
        return "\(date.monthName) \(date.day)"
    }
    
    static func toDateWithCurrentYear(date: String, dateFormat: String) -> Date {
        let addYear = "2018 \(date)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: addYear)!
    }
}

extension Formatter {
    static let month: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    static let day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    static let dayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    static let hour: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        return formatter
    }()
    static let minute: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()
    static let amPM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter
    }()
}

extension Date {
    var monthStr: String       { return Formatter.month.string(from: self) }
    var dayStr: String         { return Formatter.day.string(from: self) }
    var dayOfWeekStr: String   { return Formatter.dayOfWeek.string(from: self) }
    var hourStr:  String       { return Formatter.hour.string(from: self) }
    var minuteStr: String      { return Formatter.minute.string(from: self) }
    var amPMStr: String        { return Formatter.amPM.string(from: self) }
    
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/New_York")!
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)!
    }
}
