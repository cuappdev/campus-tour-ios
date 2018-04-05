//
//  TourData.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

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
