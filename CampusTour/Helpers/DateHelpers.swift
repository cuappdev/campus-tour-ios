//
//  DateHelpers.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/4/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

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
        var startIsPM = start.hour > 12
        var endIsPM = end.hour > 12
        
        let startFormatted = "\(startIsPM ? start.hour-12 : start.hour):\(start.minute) \(startIsPM ? "PM" : "AM")"
        let endFormatted = "\(endIsPM ? end.hour-12 : end.hour):\(end.minute) \(endIsPM ? "PM" : "AM")"
        
        return startFormatted + " - " + endFormatted
    }
}
