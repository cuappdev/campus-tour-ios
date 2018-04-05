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
    
    // Get a list of composite events
    public func getCompositeEvents(completion: @escaping ((_ success: Bool) -> Void)) {
        let eventsUrlString = "https://schedule.cornelldays.cornell.edu/api/itin/cornelldays/events/"
        guard let url = URL(string: eventsUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            
            do {
                let compEvents = try JSONDecoder().decode(CompositeEvents.self, from: data)
                self.compositeEvents = compEvents.events
                completion(true)
            } catch let error {
                print("JSON Serialization Error: ", error)
                completion(false)
            }
            }.resume()
    }
    
    // Get a list of individual events
    public func getEvents(compEvents: [CompositeEvent]) {
        var singleEvents: [Event] = []
        
        for event in compEvents {
            for time in event.times {
                let name = "\(event.title): \(time.note)"
                let locationName = (time.locationName != "") ? time.locationName : event.locationName
                let location = Location(name: locationName, lat: nil, lng: nil)
                let startTime = time.startTime.toDate(dateFormat: "MMMM, d yyyy HH:mm:ss")
                let endTime = time.endTime.toDate(dateFormat: "MMMM, d yyyy HH:mm:ss")
                let singleEvent = Event(id: time.id, compEventId: event.id, name: name, description: event.description, startTime: startTime, endTime: endTime, location: location, college: nil, type: nil, tags: event.tags)
                singleEvents.append(singleEvent)
            }
        }
        
        events = singleEvents
    }
}
