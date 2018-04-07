//
//  TestData.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/21/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//
// This will be deleted once we have the real data

import UIKit

let testEvents: [Event] = [
    Event(
        id: "A",
        compEventId: nil,
        name: "AppDev Workshop",
        description: loremIpsum,
        startTime: Date(timeIntervalSinceNow: 1000),
        endTime: Date(timeIntervalSinceNow: 3000),
        location: Location(name: "A-Lot Staff Parking", lat: 42.45844166666667, lng: -76.47668888888889),
        college: nil,
        type: nil,
        tags: [EventTag(id: "CUAPPDEV123", label: "General")]
    ),
    Event(
        id: "B",
        compEventId: nil,
        name: "AppDev Workshop",
        description: loremIpsum,
        startTime: Date(timeIntervalSinceNow: 1000),
        endTime: Date(timeIntervalSinceNow: 3000),
        location: Location(name: "A. D. White Gardens", lat: 42.44780277777777, lng: -76.48188888888889),
        college: nil,
        type: nil,
        tags: [EventTag(id: "CUAPPDEV123", label: "General")]
    ),
    Event(
        id: "C",
        compEventId: nil,
        name: "AppDev Workshop",
        description: loremIpsum,
        startTime: Date(timeIntervalSinceNow: 1000),
        endTime: Date(timeIntervalSinceNow: 3000),
        location: Location(name: "Ag Quad", lat: 42.44874223637841, lng: -76.47859920035884),
        college: nil,
        type: nil,
        tags: [EventTag(id: "CUAPPDEV123", label: "General")]
    )
]

let testPlaces: [Building] = Array(
    repeating: Building(
        tags: [College.engineering.rawValue],
        name: "Gates Hall",
        department: "CIS",
        icon: UIImage(), //TODO change to url
        location: Location(name: "Gates Hall", lat: -76.480973, lng: 42.444953)
    ), count: 20)

