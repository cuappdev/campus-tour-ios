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
    
    var mapView: GMSMapView?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellWillAppear () {
        guard mapView == nil else { return }
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 12.0))
        AppDelegate.shared!.locationProvider.addLocationListener(repeats: false) { [weak self] location in
            self?.mapView?.moveCamera(GMSCameraUpdate.setTarget(location.coordinate))
        }
        
        self.contentView.addSubview(mapView!)
        mapView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
