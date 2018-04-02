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
    let scaling = CGFloat(4.0)
    let width = UIScreen.main.bounds.width * scaling
    let height = width / 3
    let view = UIView(
        frame: CGRect(x: 0, y: 0, width: width, height: height))
    view.clipsToBounds = true
    view.backgroundColor = UIColor.clear
    
    let wrapperView = UIView()
    wrapperView.backgroundColor = UIColor.white
    wrapperView.layer.cornerRadius = 10 * scaling
    wrapperView.clipsToBounds = true
    
    let vStack = UIStackView()
    vStack.axis = .vertical
    vStack.alignment = .leading
    
    //no idea why but these views appear in reverse order
    vStack.addArrangedSubview(UILabel.label(text: "SUBTITLE",
                                            color: Colors.secondary,
                                            font: UIFont.systemFont(ofSize: 20 * scaling, weight: .medium)))
    vStack.addArrangedSubview(UILabel.label(text: item.name,
                                            color: Colors.primary,
                                            font: UIFont.systemFont(ofSize: 24 * scaling, weight: .semibold)))
    
    wrapperView.addSubview(vStack)
    vStack.snp.makeConstraints { make in
        make.edges.equalToSuperview().inset(16 * scaling)
    }
    
    view.addSubview(wrapperView)
    wrapperView.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.width.lessThanOrEqualToSuperview()
        $0.height.lessThanOrEqualToSuperview()
    }
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
    return view
}

class ARExplorerViewController: UIViewController {
    
    var testView = UIView()
    
    var itemsOfInterestAndViews: [(item: ARItemOfInterest, view: UIView)] = []
    
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
        testView.setNeedsLayout()
        testView.layoutIfNeeded()
        print("subviews")
        testView.subviews.forEach{print($0)}
    }
    
    func stopAr() {
    }

}
