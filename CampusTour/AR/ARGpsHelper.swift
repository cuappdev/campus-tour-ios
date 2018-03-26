//
//  ARGpsHelper.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/25/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit

enum ARGps {
    /// assumes that north is -z axis direction, and east is +x axis
    static func estimateDisplacement(from: CLLocation, to: CLLocation) -> SCNVector3 {
        //latitude is -z, longitude is +x
        let midCoord = CLLocation(latitude: from.coordinate.latitude, longitude: to.coordinate.longitude)
        var distanceZ = midCoord.distance(from: from)
        if to.coordinate.latitude > from.coordinate.latitude { //from -> to goes north, so -z
            distanceZ = -distanceZ
        }
        var distanceX = to.distance(from: midCoord)
        if to.coordinate.longitude < from.coordinate.longitude { //from -> to goes west, so -x
            distanceX = -distanceX
        }
        return SCNVector3(distanceX, 0.0, distanceZ)
    }
}
