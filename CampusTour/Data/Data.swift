//
//  Data.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/6/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

struct LocationData: Codable {
    var name: String
    var longitude: String
    var latitude: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case longitude
        case latitude
    }
}

class ParseData {
    var locations: [LocationData]!
    init() {
        do {
            let file_path = Bundle.main.path(forResource: "locations-clean", ofType: "json")
            guard let unwrapped_file_path = file_path else { return }
            let file = try Data(contentsOf: URL(fileURLWithPath: unwrapped_file_path))
            let file_string = String(data: file, encoding: .utf8)
            let decoder = JSONDecoder()
            locations = try decoder.decode([LocationData].self, from: file)
        } catch {
            print("There seems to be a problem...")
        }
    }
    
}
