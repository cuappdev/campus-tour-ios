//
//  SearchHelpers.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/9/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class SearchHelper {
    
    //Takes in tag as input (it is the abbreviated form of the tags)
    static func getEventsFromTag(tag: String, events: [Event]) -> [Event] {
        var tagid: String = ""
        
        generalTagMapping.forEach { tagid = $0.value == tag ? $0.key : tagid }
        
        var taggedEvents = [Event]()
        
        for e in events {
            e.tags.forEach({ (etag) in
                if etag.id == tagid { taggedEvents.append(e) }
            })
        }
        return taggedEvents
    }
    
    static func getEventsOnDate(date: Date, events: [Event]) -> [Event] {
        var onDate = [Event]()
        
        events.forEach { (event) in
            if event.startTime.isInSameDayOf(date: date) {
                onDate.append(event)
            }
        }
        return onDate
    }
    
    static func getFilteredEvents(_ filterBarCurrentStatus: FilterBarCurrentStatus) -> [Event] {
        var filteredEvents: [Event]
        //Date filter
        switch filterBarCurrentStatus.dateSelected {
        case "All Dates":
            filteredEvents = DataManager.sharedInstance.events
        case "Today":
            filteredEvents = SearchHelper.getEventsOnDate(date: Date(), events: DataManager.sharedInstance.events)
        case _:
            filteredEvents = SearchHelper.getEventsOnDate(date: DateHelper.toDateWithCurrentYear(date: filterBarCurrentStatus.dateSelected, dateFormat: "yyyy MMMM dd"), events: DataManager.sharedInstance.events)
        }
        
        //apply school filter
        if filterBarCurrentStatus.schoolSelected != "All Schools" {
            filteredEvents = SearchHelper.getEventsFromTag(tag: filterBarCurrentStatus.schoolSelected, events: filteredEvents)
        }
        
        //apply type filter
        if filterBarCurrentStatus.typeSelected != "Type" {
            filteredEvents = SearchHelper.getEventsFromTag(tag: filterBarCurrentStatus.typeSelected, events: filteredEvents)
        }
        
        //apply special interest filter
        if filterBarCurrentStatus.specialInterestSelected != "Special Interest" {
            filteredEvents = SearchHelper.getEventsFromTag(tag: filterBarCurrentStatus.specialInterestSelected, events: filteredEvents)
        }
        
        return filteredEvents
    }
    
    static func getEventById(_ id: String, events: [Event]) -> Event? {
        for event in events {
            if event.id == id { return event }
        }
        return nil
    }
}
