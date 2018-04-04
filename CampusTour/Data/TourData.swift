//
//  TourData.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

enum EventType: String {
    //Type of events
    case academic = "Academic"
    case classes = "Class"
    case general = "General"
    case officehour = "Office Hour"
    case social = "Social"
    case tour = "Tour"
}

enum College: String {
    case artsandscience = "Arts and Science"
    case engineering = "Engineering"
    case ilr = "ILR"
    case cals = "CALS"
    case hotel = "Hotel Administration"
    case aap = "Arts, Architecture, and Planning"
    case humanecology = "Human Ecology"
}

struct Location {
    var longitude: Float
    var latitude: Float
}

struct Event {
    //Use enum.rawtype to create tags
    var tags: [String]
    var name: String
    var description: String
    var location: Location
    var locationName: String
    var startTime: Date
    var endTime: Date
}

struct Building {
    var tags: [String]
    var name: String
    var department: String?
    var icon: UIImage
    var location: Location
}
