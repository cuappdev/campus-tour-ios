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
        tags: [EventType.tour.rawValue, College.engineering.rawValue],
        name: "AppDev Workshop",
        description: "Cool React workdshop! Much cooler than everything we have. Let's see how long this string can get in order to make a bad impact on the visual of our app. Let's see how long it can go. gogogogogogog. Keep on going.",
        location: Location.init(longitude: 0, latitude: 0),
        locationName: "Gates Hall",
        startTime: Date(timeIntervalSinceNow: 1000),
        endTime: Date(timeIntervalSinceNow: 3000)),
    count: 3)

let testPlaces: [Building] = Array(
    repeating: Building(
        tags: [College.engineering.rawValue],
        name: "Gates Hall",
        department: "CIS",
        icon: UIImage(), //TODO change to url
        location: Location(longitude: 42.444953, latitude: -76.480973)),
    count: 20)
