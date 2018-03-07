//
//  LocationManager.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/6/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case locationNotAvailable
}

class LocationProvider: NSObject {
    private var _currentLocation: CLLocation?
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func getLocation() throws -> CLLocation {
        guard let currentLocation = _currentLocation else {
            throw LocationError.locationNotAvailable
        }
        return currentLocation
    }
    
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self._currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
}
