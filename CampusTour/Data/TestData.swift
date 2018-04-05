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
        id: "123",
        compEventId: "234",
        name: "AppDev Workshop",
        description: "Cool React workshop!",
        startTime: Date(timeIntervalSinceNow: 1000),
        endTime: Date(timeIntervalSinceNow: 2000),
        location: Location(name: "Olin Hall 155", lat: 0, lng: 0),
        college: College.Engineering,
        type: EventType.Orientation,
        tags: []
    ), count: 3)

let testPlaces: [Building] = Array(
    repeating: Building(
        college: .Engineering,
        name: "Gates Hall",
        department: "CIS",
        icon: UIImage(), //TODO change to url
        location: Location(name: "Gates Hall", lat: -76.480973, lng: 42.444953)
    ), count: 20)


