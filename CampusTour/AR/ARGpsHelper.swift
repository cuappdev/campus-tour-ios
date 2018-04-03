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
        
        var distanceX = midCoord.distance(from: from)
        if to.coordinate.longitude < from.coordinate.longitude { // to -> from goes west -> east
            distanceX *= -1.0
        }
        
        var distanceZ = to.distance(from: midCoord)
        if to.coordinate.latitude > from.coordinate.latitude { // to -> from goes north -> south
            distanceZ *= -1.0
        }
        return SCNVector3(distanceX, 0.0, distanceZ)
    }
}
