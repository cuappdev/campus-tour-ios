//
//  MiscUIHelpers.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/21/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import GoogleMaps

extension UIViewController {
    
    func openAppleMapsDirections(_ event: Event) {
        let coords = CLLocationCoordinate2DMake(CLLocationDegrees(event.location.lat), CLLocationDegrees(event.location.lng))
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coords, addressDictionary: nil))
        mapItem.name = event.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func showDirectionsPopupView(event: Event) {
        let lat = event.location.lat
        let lng = event.location.lng
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Open in Apple Maps", style: .default) { Void in
                self.openAppleMapsDirections(event)
            })
            alertController.addAction(UIAlertAction(title: "Open in Google Maps", style: .default) { Void in
                UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lng)&directionsmode=walking")!, options: [:], completionHandler: nil)
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        } else {
            openAppleMapsDirections(event)
        }
    }
    
}

extension UIView {
    static func insetWrapper(view: UIView, insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(insets.top)
            make.right.equalToSuperview().inset(insets.right)
            make.bottom.equalToSuperview().inset(insets.bottom)
            make.left.equalToSuperview().inset(insets.left)
        }
        return wrapper
    }
}

extension UITableViewCell {
    
    func animateUponLoad(delayCount: Double) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        self.alpha = 0
        
        UIView.beginAnimations("load", context: nil)
        UIView.setAnimationDelay(0.2*delayCount)
        UIView.setAnimationDuration(0.6)
        
        self.transform = CGAffineTransform(translationX: 0, y: 0)
        self.alpha = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        UIView.commitAnimations()
    }
    
}

class SeparatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.isOpaque = false
        self.isUserInteractionEnabled = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let (width, height) = (rect.width, rect.height)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        UIColor(white: 0.9, alpha: 1.0).setStroke()
        path.stroke()
    }
}
