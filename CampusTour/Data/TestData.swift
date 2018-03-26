//
//  TestData.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/21/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//
// This will be deleted once we have the real data

import UIKit

let testEvents: [Event] = Array(
    repeating: Event(
        name: "AppDev Workshop",
        description: "Cool React workdshop!",
        location: Location.init(longitude: 0, latitude: 0),
        college: College.Engineering,
        type: EventType.Orientation,
        time: Date(timeIntervalSinceNow: 1000)),
    count: 3)

let testPlaces: [Building] = Array(
    repeating: Building(
        college: .Engineering,
        name: "Gates Hall",
        department: "CIS",
        icon: UIImage(), //TODO change to url
        location: Location(longitude: 42.444953, latitude: -76.480973)),
    count: 20)
