//
//  Data.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/6/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

let defaultLocationImageUrl = "https://statlerhotel.cornell.edu/resourcefiles/homeimages/cornell-campus-the-statler-hotel-top.jpg"

enum DataError: Error {
    case InvalidData
}

struct Locations: Decodable {
    let locations: [Location]
}

public struct Location: Codable {
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
        
        let latString = try container.decode(String.self, forKey: .lat)
        let lat = Float(latString)!
        
        let lngString = try container.decode(String.self, forKey: .lng)
        let lng = Float(lngString)!
        
        let name = try container.decode(String.self, forKey: .name)
        let category = try container.decode(String.self, forKey: .category)
        let imageUrl = try container.decode(String.self, forKey: .imageUrl)
        let address = try container.decode(String.self, forKey: .address)
        let notes = try container.decode(String.self, forKey: .notes)
        let nickname = try container.decode(String.self, forKey: .nickname)
        
        self.init(name: name, lat: lat, lng: lng, category: category, imageUrl: imageUrl, address: address, notes: notes, nickname: nickname)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(String(lat), forKey: .lat)
        try container.encode(String(lng), forKey: .lng)
        
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(address, forKey: .address)
        try container.encode(notes, forKey: .notes)
        try container.encode(nickname, forKey: .nickname)
    }
    
    func with(name: String, address: String) -> Location {
        return Location(
            name: name,
            lat: self.lat,
            lng: self.lng,
            category: self.category,
            imageUrl: self.imageUrl,
            address: address,
            notes: self.notes,
            nickname: self.nickname
        )
    }
}

struct Building {
    var tags: [String]
    var name: String
    var department: String?
    var icon: UIImage
    var location: Location
}
