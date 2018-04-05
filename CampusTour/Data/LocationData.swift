//
//  Data.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/6/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

enum DataError: Error {
    case InvalidData
}

struct Locations: Decodable {
    let locations: [Location]
}

public struct Location: Decodable {
    let name: String
    let lat: Float
    let lng: Float
    let category: String
    let imageUrl: String
    let address: String
    let notes: String
    let nickname: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case lat = "Lat"
        case lng = "Lng"
        case category = "Folder"
        case imageUrl = "ImageURL"
        case address = "Address"
        case notes = "Notes"
        case nickname = "AKA"
    }
    
    // Note we need the init functions here because JSONDecoder doesn't handle string -> float conversions automatically
    init(name: String, lat: Float, lng: Float, category: String = "", imageUrl: String = "", address: String = "", notes: String = "", nickname: String = "") {
        self.name = name
        self.category = category
        self.imageUrl = imageUrl
        self.address = address
        self.notes = notes
        self.nickname = nickname
        self.lat = lat
        self.lng = lng
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)

        let latString = try container.decode(String.self, forKey: .lat)
        let lat = Float(latString)!
        
        let lngString = try container.decode(String.self, forKey: .lng)
        let lng = Float(lngString)!
        
        self.init(name: name, lat: lat, lng: lng)
    }
}
