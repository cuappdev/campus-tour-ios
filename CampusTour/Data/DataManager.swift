//
//  DataManager.swift
//  CampusTour
//
//  Created by Annie Cheng on 4/4/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import Foundation

// Data Manager for handling the Cornell Days Data
public class DataManager {
    
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
    
    init() {
        eventsAndLocationsFetchedFuture = DataMultiTaskFuture() {
            for i in 0..<self.events.count {
                let event = self.events[i]
                if let location = self.getClosestLocation(withFullName: event.location.name) {
                    self.events[i].location = location
                } else {
                    print("location not found :( \(event.location.name)")
                }
            }
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
                self.compositeEvents = compEvents.events
                self.setEvents(compEvents: self.compositeEvents)
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
                self.locations = locations.locations
                completion(true)
            } catch let jsonError {
                print("JSON Serialization Error: ", jsonError)
                completion(false)
            }
            self.eventsAndLocationsFetchedFuture?.notifyCompletion(task: .fetchLocations)
        }.resume()
    }
    
    /// fullLocationName may contain not just the building but also the room
    func getClosestLocation(withFullName fullLocationName: String) -> Location? {
        
        if let location = (locations.first { loc in fullLocationName.contains(loc.name)}?.with(name: fullLocationName) ) {
            return location
        }
        
        //TODO make this more robust
        var result: Location? = nil
        if fullLocationName.contains("Statler Hotel") {
            result = locations.first {loc in loc.name.contains("Statler Hotel")}
        } else if fullLocationName.contains("Schwartz Center for the Performing Arts") {
            result = locations.first {loc in loc.name.contains("Schwartz Center")}
        } else if fullLocationName.contains("Baker Lab") {
            result = locations.first {loc in loc.name.contains("Baker Lab")}
        } else if fullLocationName.contains("Tatkon Center") {
            // tatkon center doesn't seem to be in cornell days' list of locations
            result = Location(
                name: "Carol Tatkon Center",
                lat: 42.453216,
                lng: -76.479394)
        } else if fullLocationName.contains("Marketplace Eatery") {
            result = locations.first {loc in loc.name.contains("Robert Purcell Community Center")}
        } else if fullLocationName.contains("Sibley Dome") {
            result = locations.first {loc in loc.name.contains("Sibley")}
        } else if fullLocationName.contains("Tjaden Hall") {
            result = locations.first {loc in loc.name.contains("Tjaden Hall")}
        } else if fullLocationName.contains("Plant Sciences Building") {
            result = locations.first {loc in loc.name.contains("Plant Science Building")}
        } else if fullLocationName.contains("Appel Commons") {
            result = locations.first {loc in loc.name.contains("Appel Commons")}
        }
        
        return result?.with(name:fullLocationName)
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
