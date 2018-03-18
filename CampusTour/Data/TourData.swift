//
//  TourData.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

enum Filter {
    //Change with filters
    case Fun
}

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

class Events {
    var name: String
    var description: String
    var dateTime: String
    var location: Location
    var college: College
    var type: EventType
    
    init(name:String, description: String, dateTime: String, location: Location, college: College, type: EventType) {
        self.name = name
        self.description = description
        self.dateTime = dateTime
        self.location = location
        self.college = college
        self.type = type
    }
}

class Building {
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

class Tour {
    var name: String
    var location: Location
    var description: String
    
    init(name: String, location: Location, description: String) {
        self.name = name
        self.location = location
        self.description = description
    }
}
