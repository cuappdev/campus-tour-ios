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
    typealias LocationListener = (CLLocation) -> ()
    struct LocationListenerWrapper {
        let listener: LocationListener
        let repeats: Bool
    }
    
    private var _currentLocation: CLLocation?
    private let locationManager: CLLocationManager
    private var locationListeners: [LocationListenerWrapper] = []
    
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
    
    /// If a location is available, call the listener immediately
    /// To remove this listener, just deallocate your reference to it
    /// Listener will only be called as long as there exists a strong reference to it
    func addLocationListener(repeats: Bool, listener: @escaping LocationListener) {
        if let location = _currentLocation {
            listener(location)
            if !repeats {
                return
            }
        }
        
        locationListeners.append(LocationListenerWrapper(
            listener: listener,
            repeats: repeats
        ))
    }
    
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self._currentLocation = location
            updateLocationListeners(location: location)
        }
    }
    
    func updateLocationListeners(location: CLLocation) {
        locationListeners.forEach {$0.listener(location)}
        locationListeners = locationListeners.filter {$0.repeats}
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
}
