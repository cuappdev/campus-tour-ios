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

private func arViewForItemOfInterest() -> UIView {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let vStack = UIStackView()
    vStack.axis = .vertical
    //vStack.addArrangedSubview()
    return view
}

class ARExplorerViewController: UIViewController {
    
    var testView = UIView()
    
    var itemsOfInterestAndViews: [(item: ARItemOfInterest, view: UIView)] = []
    
    func setItems(items: [ARItemOfInterest]) {
        
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
        sceneView.scene.rootNode.addChildNode({
            let node = SCNNode(
                geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
            return node
        }())
        
        sceneView.scene.rootNode.addChildNode({
            testView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            testView.backgroundColor = UIColor.white
            
            let testLabel = UILabel()
            testLabel.text = "hello, world!"
            testView.addSubview(testLabel)
            testLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            let plane = SCNPlane(width: 0.2, height: 0.2)
            let viewMat = SCNMaterial()
            viewMat.diffuse.contents = self.testView.layer
            plane.firstMaterial = viewMat
            
            let node = SCNNode(geometry: plane)
            node.position = SCNVector3(0, 0, -0.2)
            return node
        }())
        
        AppDelegate.shared!.locationProvider.addLocationListener(repeats: false) { [weak self] currentLocation in
            self?.initializeGpsDependentObjects(withCurrentLocation: currentLocation)
        }
    }
    
    func initializeGpsDependentObjects(withCurrentLocation currentLocation: CLLocation) {
        self.itemsOfInterest.forEach { item in
            let itemNode = SCNNode(geometry: SCNPlane(width: 50, height: 50))
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
