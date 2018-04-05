//
//  LocationMarker.swift
//  CampusTour
//
//  Created by Annie Cheng on 4/5/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class LocationMarker: UIView {
    
    var eventLabel: UILabel!
    var circleView: UIView!
    var circleViewDiameter: CGFloat!
    var triangleLength: CGFloat!
    var fontSize: CGFloat!
    
    init(circleViewDiameter: CGFloat = 35, triangleLength: CGFloat = 0.2, fontSize: CGFloat = 11) {
        super.init(frame: CGRect(x: 0, y: 0, width: circleViewDiameter, height: 1.5 * circleViewDiameter))
        
        self.circleViewDiameter = circleViewDiameter
        self.triangleLength = triangleLength
        self.fontSize = fontSize
        
        let markerFrame = CGRect(x: 0, y: 0, width: circleViewDiameter, height: circleViewDiameter)
        backgroundColor = .clear
        
        // Marker Circle
        circleView = UIView(frame: markerFrame)
        circleView.backgroundColor = Colors.brand
        circleView.layer.cornerRadius = circleView.frame.height / 2.0
        circleView.layer.masksToBounds = true
        addSubview(circleView)
        
        // Event number label
        eventLabel = UILabel(frame: markerFrame)
        eventLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: fontSize)
        eventLabel.textAlignment = .center
        eventLabel.textColor = .white
        eventLabel.numberOfLines = 0
        circleView.addSubview(eventLabel)
        
        // Marker triangle
        let triangle = drawTriangle()
        layer.addSublayer(triangle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func drawTriangle() -> CAShapeLayer {
        let desiredLineWidth: CGFloat = 5
        
        let trianglePath = UIBezierPath()
        let triangleBottom = circleView.frame.midY + circleViewDiameter / 4
        trianglePath.move(to: CGPoint(x: frame.midX - (triangleLength * circleViewDiameter), y: triangleBottom))
        trianglePath.addLine(to: CGPoint(x: frame.midX + (triangleLength * circleViewDiameter), y: triangleBottom))
        trianglePath.addLine(to: CGPoint(x: frame.midX , y: circleView.frame.midY + (0.55 * circleViewDiameter)))
        trianglePath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = trianglePath.cgPath
        shapeLayer.fillColor = Colors.brand.cgColor
        shapeLayer.strokeColor = Colors.brand.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        return shapeLayer
    }
    
}
