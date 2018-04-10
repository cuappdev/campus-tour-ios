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

let maximumDistanceOfARMarkersMeters: Double = 200.0

private func makeArLoadingIndicator() -> UIView {
    let indicator = LoadingIndicator()
    return indicator
}

struct ItemViewInfo {
    let item: ARItemOfInterest
    let view: ARItemOfInterestView
    var node: SCNNode?
}

class ARExplorerViewController: UIViewController {
    
    private let arQueue = DispatchQueue.init(label: "ARExplorerViewController.arQueue")
    
    var itemsOfInterestAndViews: [ItemViewInfo] = []
    
    private var camera: ARCamera? {
        return self.sceneView.session.currentFrame?.camera
    }
    
    private var sceneView: ARSCNView! = nil
    
    private var loadingIndicatorView: UIView? = nil
    
    private var previousRecordedLocation: CLLocation? = nil
    
    static func withDefaultData() -> ARExplorerViewController {
        let locations = DataManager.sharedInstance.locations
        let items = locations.map { ARItemOfInterest(
            name: $0.name,
            location: CLLocation(
                latitude: CLLocationDegrees($0.lat),
                longitude: CLLocationDegrees($0.lng)))
        }
        
        let arVc = ARExplorerViewController()
        arVc.setItems(items:items)
        
        print("init arVc parsed items with count: \(arVc.itemsOfInterestAndViews.count)")
        
        return arVc
    }
    
    override func loadView() {
        self.view = UIView()
        
        sceneView = ARSCNView()
        self.view.addSubview(sceneView)
        sceneView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let backButton = UIButton() //TODO make this look better
        backButton.setTitle("X", for: .normal)
        backButton.backgroundColor = UIColor.red
        backButton.layer.cornerRadius = 10
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(closeArAndReturn), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        self.loadingIndicatorView = makeArLoadingIndicator()
        self.view.addSubview(self.loadingIndicatorView!)
        self.loadingIndicatorView!.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
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
        AppDelegate.shared!.locationProvider.addLocationListener(repeats: true) { [weak self] currentLocation in
            DispatchQueue.main.async {
                self?.loadingIndicatorView?.removeFromSuperview()
                self?.loadingIndicatorView = nil
            }
            self?.arQueue.async {
                self?.previousRecordedLocation = currentLocation
                self?.updateLocation(currentLocation: currentLocation)
            }
        }
    }
    
    func startAr() {
        let trackingConfig = ARWorldTrackingConfiguration()
        trackingConfig.worldAlignment = .gravityAndHeading
        sceneView.session.run(trackingConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func stopAr() {
        sceneView.session.pause()
    }
    
    func setItems(items: [ARItemOfInterest]) {
        self.arQueue.sync {
            DispatchQueue.main.async {
                for info in self.itemsOfInterestAndViews {
                    info.node?.removeFromParentNode()
                }
                
                self.itemsOfInterestAndViews = items.map {
                    ItemViewInfo(item: $0,
                                 view: ARItemOfInterestView(item: $0),
                                 node: nil)
                }
            }
            
            if let location = self.previousRecordedLocation {
                self.updateLocation(currentLocation: location)
            }
        }
    }
    
    @IBAction func closeArAndReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
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
    
    /// Updates scene based on new location. Must be called on the arQueue thread
    func updateLocation(currentLocation: CLLocation) {
        for (i, infoBefore) in self.itemsOfInterestAndViews.enumerated() {
            
            //initialize the marker's node if it doesn't exist
            if infoBefore.node == nil {
                let planeWidth = CGFloat(2) //maximum width for the scene view in meters
                var plane : SCNPlane!
                DispatchQueue.main.sync {
                    plane = SCNPlane(width: planeWidth,
                                     height: planeWidth * (infoBefore.view.frame.height / infoBefore.view.frame.width))
                    plane.firstMaterial!.diffuse.contents = infoBefore.view.layer
                }
                plane.firstMaterial?.isDoubleSided = true
                let itemNode = SCNNode(geometry: plane)
                //TODO this calculates position in camera space but the position is needed in world space.
                let displacement = ARGps.estimateDisplacement(from: currentLocation, to: infoBefore.item.location)
                
                itemNode.position = displacement
                itemNode.constraints = [
                    makeItemViewConstraint()
                ]
                self.sceneView.scene.rootNode.addChildNode(itemNode)
                self.itemsOfInterestAndViews[i].node = itemNode
            }
            
            //TODO update existing nodes and filter based on distance
            if let camera = self.camera,
                let node = self.itemsOfInterestAndViews[i].node
            {
                let distance = (camera.transform.extractTranslation() - node.simdPosition).norm()
                if Double(distance) > maximumDistanceOfARMarkersMeters {
                    node.isHidden = true
                } else {
                    node.isHidden = false
                }
                
                DispatchQueue.main.sync {
                    self.itemsOfInterestAndViews[i].view.updateSubtitleWithDistance(meters: Double(distance))
                }
            }
        }
    }

}
