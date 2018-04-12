//
//  EventData.swift
//  CampusTour
//
//  Created by Annie Cheng on 4/4/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import Foundation

struct EventTag: Codable {
    let id: String
    let label: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "TAG_ID"
        case label = "TAG_LABEL"
    }
}

struct EventTime: Codable {
    let id: String
    let startTime: String
    let endTime: String
    let locationName: String
    let note: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "TIME_ID"
        case startTime = "TIME_START"
        case endTime = "TIME_END"
        case locationName = "TIME_LOCATION_OVERRIDE"
        case note = "TIME_NOTE"
    }
}

public struct CompositeEvent: Codable {
    let tags: [EventTag]
    let externalRegistrationUrl: String
    let times: [EventTime]
    let description: String
    let id: String
    let additionalFee: String
    let externalUrl: String
    let title: String
    let locationName: String
    
    private enum CodingKeys: String, CodingKey {
        case tags = "EVENT_TAGS"
        case externalRegistrationUrl = "EVENT_EXTERNAL_REGISTRATION_URL"
        case times = "EVENT_TIMES"
        case description = "EVENT_DESCRIPTION"
        case id = "EVENT_ID"
        case additionalFee = "EVENT_ADDITIONAL_FEE"
        case externalUrl = "EVENT_EXTERNAL_URL"
        case title = "EVENT_TITLE"
        case locationName = "EVENT_LOCATION"
    }
}

struct Meta: Decodable {
    let eventStatus: String
    let filterTags: String
    let numEvents: Int
    let requestTime: String
    
    private enum CodingKeys: String, CodingKey {
        case eventStatus = "EVENT_STATUS"
        case filterTags = "FILTER_TAGS"
        case numEvents = "NUM_EVENTS"
        case requestTime = "REQUESTTIME"
    }
}

struct CompositeEvents: Decodable {
    let events: [CompositeEvent]
    let meta: Meta
    
    private enum CodingKeys: String, CodingKey {
        case events = "EVENTS"
        case meta = "META"
    }
}

enum EventType: String, Codable {
    //Type of events
    case academic = "Academic"
    case classes = "Class"
    case general = "General"
    case officehour = "Office Hour"
    case social = "Social"
    case tour = "Tour"
}

enum College: String, Codable {
    case artsandscience = "Arts and Science"
    case engineering = "Engineering"
    case ilr = "ILR"
    case cals = "CALS"
    case hotel = "Hotel Administration"
    case aap = "Architecture, Art, and Planning"
    case humanecology = "Human Ecology"
    case jcbdyson = "JCB Dyson School"
    case jcbhotel = "JCB Hotel School"
}

public struct Event: Codable {
    let id: String
    let compEventId: String?
    let name: String
    let description: String
    let startTime: Date
    let endTime: Date
    var location: Location
    let college: College?
    let type:  EventType?
    let tags: [EventTag]
    
    func with(location: Location) -> Event {
        return Event(
            id: self.id,
            compEventId: self.compEventId,
            name: self.name,
            description: self.description,
            startTime: self.startTime,
            endTime: self.endTime,
            location: location,
            college: self.college,
            type: self.type,
            tags: self.tags)
    }
    
    func parseTag() -> [String] {
        var strTags = [String]()
        for tag in self.tags {
            guard let abbv = tag.generalTagMap(id: tag.id) else { continue }
            strTags.append(abbv)
        }
        return strTags
    }
    
    static func removeDuplicateLocations(events: [Event]) -> [Event] {
        var result = [Event]()
        for event in events {
            if result.contains (where: {
                $0.location.lng == event.location.lng && $0.location.lat == event.location.lat
            }) {
                continue
            } else {
                result.append(event)
            }
        }
        return result
    }
}

extension Array where Element == Event {
    func sortedChronologically() -> [Event] {
        return self.sorted {$0.startTime < $1.startTime}
    }
    
    func afterNow() -> [Event] {
        return self.filter {Date() < $0.endTime}
    }
}
