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

struct ItemViewInfo {
    let item: ARItemOfInterest
    let view: ARItemOfInterestView
    var node: SCNNode?
}

class ARExplorerViewController: UIViewController {
    
    var itemsOfInterestAndViews: [ItemViewInfo] = []
    
    private var camera: ARCamera? {
        return self.sceneView.session.currentFrame?.camera
    }
    
    private var sceneView: ARSCNView! = nil
    
    static func withDefaultData() -> ARExplorerViewController {
        let arVc = ARExplorerViewController()
        
        do {
            DataManager.sharedInstance.getLocations { (success) in
                if success {
                    let locations = DataManager.sharedInstance.locations
                    
                    arVc.setItems(items:
                        locations.map { ARItemOfInterest(
                            name: $0.name,
                            location: CLLocation(
                                latitude: CLLocationDegrees($0.lat),
                                longitude: CLLocationDegrees($0.lng)))
                    })

                    print("init arVc parsed items with count: \(arVc.itemsOfInterestAndViews.count)")
                }
            }
        } catch let e {
            print(e)
        }
        
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
    }
    
    func setItems(items: [ARItemOfInterest]) {
        itemsOfInterestAndViews = items.map {
            ItemViewInfo(item: $0,
                         view: ARItemOfInterestView(item: $0),
                         node: nil)
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
    
    
    func updateLocation(currentLocation: CLLocation) {
        for (i, info) in self.itemsOfInterestAndViews.enumerated() {
            if info.node == nil { //initialize node
                let planeWidth = CGFloat(2) //maximum width for the scene view in meters
                let plane = SCNPlane(width: planeWidth,
                                     height: planeWidth * (info.view.frame.height / info.view.frame.width))
                plane.firstMaterial!.diffuse.contents = info.view.layer
                plane.firstMaterial?.isDoubleSided = true
                let itemNode = SCNNode(geometry: plane)
                let displacement = ARGps.estimateDisplacement(from: currentLocation, to: info.item.location)
                
                itemNode.position = displacement
                itemNode.constraints = [
                    makeItemViewConstraint()
                ]
                self.sceneView.scene.rootNode.addChildNode(itemNode)
                self.itemsOfInterestAndViews[i].node = itemNode
            }
            
            if let camera = self.camera,
                let node = info.node
            {
                let distance = (camera.transform.extractTranslation() - node.simdPosition).norm()
                info.view.updateSubtitleWithDistance(meters: Double(distance))
            }
        }
    }

}
