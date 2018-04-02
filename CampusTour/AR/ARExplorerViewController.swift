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

class ARExplorerViewController: UIViewController {
    
    var itemsOfInterestAndViews: [(item: ARItemOfInterest, view: ARItemOfInterestView)] = []
    
    func makeItemViewConstraint() -> SCNTransformConstraint {
        return SCNTransformConstraint(
            inWorldSpace: true,
            with: { [weak self] (node: SCNNode, matrix: SCNMatrix4) in
                guard let camera = self?.camera else {
                    return matrix
                }
                let cameraPosition = camera.transform.extractTranslation()
                let nodePosition = node.simdWorldPosition
                var result = float4x4.identity()
                
                //make rotation
                let direction = (cameraPosition - nodePosition).normalize()
                result = matrix4LookAtZ(direction: direction) * result
                
                //restore position
                result.columns.3 = float4x4(matrix).columns.3
                
                //scaling
                let minimumDistanceForExpansion : Float = 5.0
                let imaginaryCameraOffset : Float = 10.0
                let dist = (cameraPosition - nodePosition).norm()
                if dist > minimumDistanceForExpansion {
                    result = result * float4x4.scale(
                        (imaginaryCameraOffset + dist) / (imaginaryCameraOffset + minimumDistanceForExpansion))
                }
                
                return SCNMatrix4(result)
        })
    }
    
    private var camera: ARCamera? {
        return self.sceneView.session.currentFrame?.camera
    }
    
    func setItems(items: [ARItemOfInterest]) {
        itemsOfInterestAndViews = items.map { (item: $0, view: createVirtualView(item: $0)) }
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
        let repeatingLocationListener : (CLLocation) -> () = {[weak self] currentLocation in
            self?.updateLocation(currentLocation: currentLocation)
        }
        
        AppDelegate.shared!.locationProvider.addLocationListener(repeats: false) { [weak self] currentLocation in
            self?.initializeGpsDependentObjects(withCurrentLocation: currentLocation)
            AppDelegate.shared!.locationProvider.addLocationListener(repeats: true, listener: repeatingLocationListener)
        }
    }
    
    func updateLocation(currentLocation: CLLocation) {
        self.itemsOfInterestAndViews.forEach { item , itemView in
            itemView.updateSubtitleWithDistance(meters: item.location.distance(from: currentLocation))
        }
    }
    
    func initializeGpsDependentObjects(withCurrentLocation currentLocation: CLLocation) {
        self.itemsOfInterestAndViews.forEach { item, itemView in
            let planeWidth = CGFloat(2) //maximum width for the scene view in meters
            let plane = SCNPlane(width: planeWidth,
                                 height: planeWidth * (itemView.frame.height / itemView.frame.width))
            plane.firstMaterial!.diffuse.contents = itemView.layer
            //plane.firstMaterial?.transparent.contents
            plane.firstMaterial?.isDoubleSided = true
            let itemNode = SCNNode(geometry: plane)
            let displacement = ARGps.estimateDisplacement(from: currentLocation, to: item.location)
            
            itemNode.position = displacement
            itemNode.constraints = [
                makeItemViewConstraint()
            ]
            self.sceneView.scene.rootNode.addChildNode(itemNode)
        }
    }
    
    func startAr() {
        let trackingConfig = ARWorldTrackingConfiguration()
        trackingConfig.worldAlignment = .gravityAndHeading
        sceneView.session.run(trackingConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func stopAr() {
    }

}
