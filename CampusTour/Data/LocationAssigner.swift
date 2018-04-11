//
//  LocationAssigner.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 4/8/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import Foundation

/// Addresses for locations that have no given addresses
private var locationAddresses: [String:String] = [
    "Beebe Lake": "101 Forest Home Dr, Ithaca, NY 14850",
    "Biotechnology Building": "526 Campus Rd Ithaca, NY 14850",
    "Johnson Museum of Art": "114 Central Ave, Ithaca, NY 14853",
    "Klarman Hall": "232 East Ave, Ithaca, NY 14850",
    "McGraw Hall": "215 Tower Rd, Ithaca, NY 14853",
    "Statler Hall": "7 East Ave, Ithaca, NY 14853"
]

private func getAddress(location: Location) -> String {
    return locationAddresses[location.name] ?? location.address
}

private func getClosestLocation(
    withFullName fullLocationName: String,
    locationTokens: [[String]],
    locations: [Location]
    ) -> Location?
{
    //look for locations that don't perfectly match
    var result: Location?
    if fullLocationName.contains("Baker Lab") {
        result = locations.first {loc in loc.name.contains("Baker Lab")}
    } else if fullLocationName.contains("Tatkon Center") {
        // tatkon center doesn't seem to be in cornell days' list of locations
        result = Location(
            name: "Carol Tatkon Center",
            lat: 42.453216,
            lng: -76.479394,
            address: "Cradit Farm Dr, Ithaca, NY 14850"
        )
    } else if fullLocationName.contains("Marketplace Eatery") {
        result = locations.first {loc in loc.name.contains("Robert Purcell Community Center")}
    }
    if let res = result {
        return res.with(name: fullLocationName, address: res.address)
    }
    
    let fullLocationNameTokens = tokenize(str: fullLocationName)
    
    var mostSimilarLocation = (similarWords: -1,
                               location: Location.init(name: "", lat: 0, lng: 0))
    for (i, tokenSet) in locationTokens.enumerated() {
        let location = locations[i]
        let newSimilarityInfo = (similarWords: similarWords(a: fullLocationNameTokens, b: tokenSet),
                                 location: location.with(name: fullLocationName, address: getAddress(location: location)))
        if newSimilarityInfo.similarWords > mostSimilarLocation.similarWords {
            mostSimilarLocation = newSimilarityInfo
        }
    }
    
    return mostSimilarLocation.location
}

func tokenize(str: String) -> [String] {
    return str
        .components(separatedBy: [" ", ","])
        .filter {!$0.isEmpty}
}

private func similarWords(a: [String], b: [String]) -> Int {
    
    var commonWords = 0
    for word in a {
        if b.contains(word) {
            commonWords += 1
        }
    }
    
    return commonWords
}

enum LocationAssigner {
    
    static func assignLocationsToEvents(events: [Event], locations: [Location]) -> [Event] {
        return benchmark(label: "assignLocations") {
            var result = [Event]()
            
            let eventLocationTokens = events.map { tokenize(str: $0.location.name) }
            let locationsTokens = locations.map { tokenize(str: $0.name)}
            
            for event in events {
                if let location = getClosestLocation(withFullName: event.location.name,
                                                     locationTokens: locationsTokens,
                                                     locations: locations) {
                    result.append(event.with(location: location))
                } else {
                    result.append(event)
                }
            }
            return result
        }
    }
    
}
