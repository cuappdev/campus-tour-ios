//
//  MapTableViewCell.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import GoogleMaps

class MapTableViewCell: UITableViewCell {
    static let reuseId = "MapTableViewCell"
    
    var mapView: GMSMapView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellWillAppear () {
        guard mapView == nil else { return }
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 42.447699, longitude: -76.484617, zoom: 12.0)) // Randomly map to Cornell Store location
        
        contentView.addSubview(mapView!)
        mapView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showLocationMarker(locations: [Location]) {
        var markers: [GMSMarker] = []
        
        // Set location markers
        for location in locations {
            let coords = CLLocationCoordinate2DMake(CLLocationDegrees(location.lat), CLLocationDegrees(location.lng))
            
            let marker = GMSMarker(position: coords)
            marker.userData = location
            marker.iconView = EventMarker()
            marker.map = mapView
            markers.append(marker)
        }
        
        // Set map bounds to show all location markers
        DispatchQueue.main.async {
            var bounds = GMSCoordinateBounds()
            
            for marker in markers {
                bounds = bounds.includingCoordinate(marker.position)
            }
            
            let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 50)
            self.mapView.animate(with: cameraUpdate)
        }
    }
    
}
