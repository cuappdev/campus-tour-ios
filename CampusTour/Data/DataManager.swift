//
//  DataManager.swift
//  CampusTour
//
//  Created by Annie Cheng on 4/4/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import Foundation
import SwiftDate

// Data Manager for handling the Cornell Days Data
public class DataManager: Codable {
    
    private let dataQueue = DispatchQueue(label: "DataManager.dataQueue")
    
    /// called when data is fetched and locations are parsed
    var onDataFetchingComplete : (() -> ())? = nil
    
    // Gives a shared instance of `DataManager`
    public static let sharedInstance = DataManager()
    
    // List of all composite events
    private (set) public var compositeEvents: [CompositeEvent] = []
    
    // List of all individual events
    private (set) public var events: [Event] = []
    
    // List of all locations
    private (set) public var locations: [Location] = []
    
    // List of all unique start dates
    private (set) public var times: [String] = []
    
    private var eventsAndLocationsFetchedFuture: DataMultiTaskFuture? = nil
    
    enum CodingKeys: CodingKey {
        case compositeEvents, events, locations, times
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataManager.CodingKeys.self)
        self.compositeEvents = try container.decode([CompositeEvent].self, forKey: .compositeEvents)
        self.events = try container.decode([Event].self, forKey: .events)
        self.locations = try container.decode([Location].self, forKey: .locations)
        self.times = try container.decode([String].self, forKey: .times)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DataManager.CodingKeys.self)
        try container.encode(compositeEvents, forKey: CodingKeys.compositeEvents)
        try container.encode(events, forKey: .events)
        try container.encode(locations, forKey: .locations)
        try container.encode(times, forKey: .times)
    }
    
    static func precomputed() throws -> DataManager {
        let path = Bundle.main.path(forResource: "precomputed_data", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONDecoder().decode(self, from: data)
    }
    
    init() {
        eventsAndLocationsFetchedFuture = DataMultiTaskFuture() {
            let newEvents =
                LocationAssigner.assignLocationsToEvents(
                    events: self.events,
                    locations: self.locations)
            self.dataQueue.sync {
                self.events = newEvents
            }
            self.onDataFetchingComplete?()
        }
    }
    
    // Get a list of composite events
    public func getEvents(completion: @escaping ((_ success: Bool) -> Void)) {
        let eventsUrlString = "https://schedule.cornelldays.cornell.edu/api/itin/cornelldays/events/"
        guard let url = URL(string: eventsUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            
            do {
                let compEvents = try JSONDecoder().decode(CompositeEvents.self, from: data)
                self.dataQueue.sync {
                    self.compositeEvents = compEvents.events
                    self.setEvents(compEvents: self.compositeEvents)
                }
                completion(true)
            } catch let error {
                print("JSON Serialization Error: ", error)
                completion(false)
            }
            self.eventsAndLocationsFetchedFuture?.notifyCompletion(task: .fetchEvents)
        }.resume()
    }
    
    // Get a list of individual events
    public func setEvents(compEvents: [CompositeEvent]) {
        var singleEvents: [Event] = []
        var uniqueTimes: Set<String> = []
        
        for event in compEvents {
            let isClassEvent = event.tags.contains {$0.label == "Class"}
            
            if isClassEvent {
                let name = event.title
                let location = Location(name: "Day Hall", lat: 0, lng: 0)
                guard let firstEventTime = event.times.first else {
                    continue
                }
                
                let startTimes = event.times.map{$0.startTime.toDate(dateFormat: "MMMM, d yyyy HH:mm:ss")}
                let endTimes = event.times.map {$0.endTime.toDate(dateFormat: "MMMM, d yyyy HH:mm:ss")}
                
                let startTime = startTimes.sorted().first!
                let endTime = endTimes.sorted().first!
                
                let singleEvent = Event(
                    id: event.id,
                    compEventId: event.id,
                    name: name,
                    description: event.description,
                    startTime: startTime,
                    endTime: endTime,
                    location: location,
                    college: nil,
                    type: nil,
                    tags: event.tags)
                singleEvents.append(singleEvent)
                uniqueTimes.insert(DateHelper.getFormattedMonthAndDay(startTime))
            } else {
                
                for time in event.times {
                    let name = "\(event.title): \(time.note)"
                    let locationName = (time.locationName != "") ? time.locationName : event.locationName
                    
                    let location = Location(name: locationName, lat: 0, lng: 0)
                    
                    let startTime = time.startTime.toDate(dateFormat: "MMMM, d yyyy HH:mm:ss")
                    let endTime = time.endTime.toDate(dateFormat: "MMMM, d yyyy HH:mm:ss")
                    let singleEvent = Event(id: time.id, compEventId: event.id, name: name, description: event.description, startTime: startTime, endTime: endTime, location: location, college: nil, type: nil, tags: event.tags)
                    singleEvents.append(singleEvent)
                    uniqueTimes.insert(DateHelper.getFormattedMonthAndDay(startTime))
                }
            }
        }
        times = Array(uniqueTimes).sorted()
        events = singleEvents
    }
    
    // Get a list of locations 
    public func getLocations(completion: @escaping ((_ success: Bool) -> Void)) {
        let locationUrlString = "https://www.cornell.edu/about/maps/locations.cfm?returnJSON=1"
        guard let url = URL(string: locationUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            
            do {
                let locations = try JSONDecoder().decode(Locations.self, from: data)
                
                self.dataQueue.sync {
                    self.locations = locations.locations
                }
                
                completion(true)
            } catch let jsonError {
                print("JSON Serialization Error: ", jsonError)
                completion(false)
            }
            self.eventsAndLocationsFetchedFuture?.notifyCompletion(task: .fetchLocations)
        }.resume()
    }

}

//maybe bring in AwaitKit instead of this
class DataMultiTaskFuture {
    enum TaskKind {
        case fetchLocations, fetchEvents
    }
    
    let onComplete: () -> ()
    private var completedTasks = Set<TaskKind>()
    private var onCompleteExecuted = false
    
    init(onComplete: @escaping () -> ()) {
        self.onComplete = onComplete
    }
    
    func notifyCompletion(task: TaskKind) {
        completedTasks.insert(task)
        
        if completedTasks.count == 2 && !onCompleteExecuted {
            onCompleteExecuted = true
            onComplete()
        }
    }
}
