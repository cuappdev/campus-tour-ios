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
        id: "ABC23",
        compEventId: nil,
         name: "AppDev Workshop",
         description: loremIpsum,
         startTime: Date(timeIntervalSinceNow: 1000),
         endTime: Date(timeIntervalSinceNow: 3000),
         location: nil,
         college: nil,
         type: nil,
         tags: [EventTag(id: "4432D6B5-9DAA-484F-1BA06B88A600DD13", label: "A&S"), EventTag(id: "4451C683-00C9-86AE-6FAAAC051F27BA11", label: "Tour")]),
    count: 3)

let testPlaces: [Building] = Array(
    repeating: Building(
        tags: [College.engineering.rawValue],
        name: "Gates Hall",
        department: "CIS",
        icon: UIImage(), //TODO change to url
        location: Location(name: "Gates Hall", lat: -76.480973, lng: 42.444953)
    ), count: 20)

