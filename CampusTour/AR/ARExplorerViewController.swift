//
//  ARExplorerViewController.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/25/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import SceneKit
import CoreLocation
import ARKit
import SnapKit

struct ARItemOfInterest {
    let name: String
    let location: CLLocation
}

private func arViewForItemOfInterest(item: ARItemOfInterest) -> UIView {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
    view.clipsToBounds = true
    view.layer.cornerRadius = 10
    view.backgroundColor = UIColor.white
    
    let vStack = UIStackView()
    vStack.axis = .vertical
    vStack.alignment = .leading
    
    //no idea why but these views appear in reverse order
    vStack.addArrangedSubview(UILabel.label(text: "SUBTITLE",
                                            color: Colors.secondary,
                                            font: UIFont.systemFont(ofSize: 14, weight: .medium)))
    vStack.addArrangedSubview(UILabel.label(text: item.name,
                                            color: Colors.primary,
                                            font: UIFont.systemFont(ofSize: 18, weight: .semibold)))
    
    view.addSubview(vStack)
    vStack.snp.makeConstraints { make in
        make.edges.equalToSuperview().inset(8)
    }
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
    return view
}

class ARExplorerViewController: UIViewController {
    
    var testView = UIView()
    
    var itemsOfInterestAndViews: [(item: ARItemOfInterest, view: UIView)] = []
    
    func setItems(items: [ARItemOfInterest]) {
        itemsOfInterestAndViews = items.map { (item: $0, view: arViewForItemOfInterest(item: $0)) }
    }
    
    var sceneView: ARSCNView {
        return self.view as! ARSCNView
    }
    
    override func loadView() {
        self.view = ARSCNView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAr()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAr()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAr()
    }
    
    func initializeAr() {
        AppDelegate.shared!.locationProvider.addLocationListener(repeats: false) { [weak self] currentLocation in
            self?.initializeGpsDependentObjects(withCurrentLocation: currentLocation)
        }
    }
    
    func initializeGpsDependentObjects(withCurrentLocation currentLocation: CLLocation) {
        self.itemsOfInterestAndViews.forEach { item, itemView in
            let planeWidth = CGFloat(10)
            let plane = SCNPlane(width: planeWidth,
                                 height: planeWidth * (itemView.frame.height / itemView.frame.width))
            plane.firstMaterial!.diffuse.contents = itemView.layer
            let itemNode = SCNNode(geometry: plane)
            let displacement = ARGps.estimateDisplacement(from: currentLocation, to: item.location)
            
            itemNode.position = displacement
            itemNode.constraints = [
                {
                    let c = SCNBillboardConstraint()
                    c.freeAxes = [SCNBillboardAxis.X, SCNBillboardAxis.Y]
                    return c
                }()
            ]
            self.sceneView.scene.rootNode.addChildNode(itemNode)
        }
    }
    
    func startAr() {
        let trackingConfig = ARWorldTrackingConfiguration()
        trackingConfig.worldAlignment = .gravityAndHeading
        sceneView.session.run(trackingConfig, options: [.resetTracking, .removeExistingAnchors])
        testView.setNeedsLayout()
        testView.layoutIfNeeded()
        print("subviews")
        testView.subviews.forEach{print($0)}
    }
    
    func stopAr() {
    }

}
