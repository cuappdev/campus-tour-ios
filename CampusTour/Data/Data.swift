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

struct LocationData: Codable {
    var name: String
    var longitude: Float
    var latitude: Float
    
    private enum CodingKeys: String, CodingKey {
        case name
        case longitude
        case latitude
    }
}

class ParseData {
    var locations: [LocationData]!
    init() throws {
        do {
            let file_path = Bundle.main.path(forResource: "locations-clean", ofType: "json")
            guard let unwrapped_file_path = file_path else { return }
            let file = try Data(contentsOf: URL(fileURLWithPath: unwrapped_file_path))
            let decoder = JSONDecoder()
            locations = try decoder.decode([LocationData].self, from: file)
        } catch {
            throw DataError.InvalidData
        }
    }
    
}
