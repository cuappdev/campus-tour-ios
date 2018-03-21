//
//  TourData.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

enum EventType {
    //Type of events
    case Orientation
    case Meals
}

enum College {
    case ArtsScience
    case Engineering
    case ILR
    case CALS
    case Hotel
    case AAP
    case HumanEcology
}

struct Location {
    var longitude: Float
    var latitude: Float
    
    init(longitude: Float, latitude: Float) {
        self.longitude = longitude
        self.latitude = latitude
    }
}

struct Event {
    var name: String
    var description: String
    var location: Location
    var college: College
    var type: EventType
    var time: Date
    
    init(name:String, description: String, time: Double, location: Location, college: College, type: EventType) {
        self.name = name
        self.description = description
        self.location = location
        self.college = college
        self.type = type
        self.time = Date.init(timeIntervalSince1970: time)
    }
}

struct Building {
    var college: College?
    var name: String
    var department: String?
    var icon: UIImage
    var location: Location
    
    init(college: College?, name: String, department: String?, icon: UIImage, location: Location) {
        self.college = college
        self.name = name
        self.department = department
        self.icon = icon
        self.location = location
    }
}

struct Tour {
    var name: String
    var location: Location
    var description: String
    var time: Date
    
    init(name: String, location: Location, description: String, time: Double) {
        self.name = name
        self.location = location
        self.description = description
        self.time = Date.init(timeIntervalSince1970: time)
    }
}
