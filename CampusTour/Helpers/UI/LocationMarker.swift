//
//  LocationMarker.swift
//  CampusTour
//
//  Created by Annie Cheng on 4/5/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

enum LocationMarkerType {
    case event
    case selectedEvent
    case place
}

class LocationMarker: UIView {
    
    let circleViewDiameter: CGFloat = 35
    
    var eventLabel: UILabel!
    var circleView: UIView!
    var clicked: Bool!
    var markerType: LocationMarkerType!
    var markerFrame: CGRect!
    
    init(markerType: LocationMarkerType) {
        super.init(frame: CGRect(x: 0, y: 0, width: circleViewDiameter, height: 1.5 * circleViewDiameter))
        
        self.markerType = markerType

        markerFrame = CGRect(x: 0, y: 0, width: circleViewDiameter, height: circleViewDiameter)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        drawRedMarker()
        
        switch(markerType) {
            case .event:
                drawEventLabel(selected: false)
            case .selectedEvent:
                let innerWhiteCircle = drawCircle(diameter: 30, color: UIColor.white.cgColor)
                let innerTriangle = drawTriangle(inner: true)
                
                innerWhiteCircle.zPosition = 2
                innerTriangle.zPosition = 3
                
                circleView.layer.addSublayer(innerWhiteCircle)
                layer.addSublayer(innerTriangle)
                drawEventLabel(selected: true)
            case .place:
                let innerWhiteCircle = drawCircle(diameter: 30, color: UIColor.white.cgColor)
                let innerRedCircle = drawCircle(diameter: 12, color: Colors.brand.cgColor)
                let innerTriangle = drawTriangle(inner: true)
                
                innerWhiteCircle.zPosition = 2
                innerRedCircle.zPosition = 3
                innerTriangle.zPosition = 4
                
                circleView.layer.addSublayer(innerWhiteCircle)
                circleView.layer.addSublayer(innerRedCircle)
                layer.addSublayer(innerTriangle)
            default:
                break
        }
    }
    
    internal func drawRedMarker() {
        // Marker Circle
        circleView = UIView(frame: markerFrame)
        circleView.backgroundColor = Colors.brand
        circleView.layer.cornerRadius = circleView.frame.height / 2.0
        circleView.layer.masksToBounds = true
        circleView.layer.zPosition = 1
        addSubview(circleView)

        // Marker triangle
        let triangle = drawTriangle(inner: false)
        triangle.zPosition = 0
        layer.addSublayer(triangle)
    }
    
    internal func drawEventLabel(selected: Bool) {
        // Event number label
        eventLabel = UILabel(frame: markerFrame)
        eventLabel.font = UIFont(name: "SFUIDisplay-Heavy", size: 11)
        eventLabel.textAlignment = .center
        eventLabel.textColor = selected ? Colors.brand : .white
        eventLabel.numberOfLines = 0
        eventLabel.layer.zPosition = 4
        eventLabel.text = "1"
        circleView.addSubview(eventLabel)
    }
    
    internal func drawTriangle(inner: Bool) -> CAShapeLayer {
        let desiredLineWidth: CGFloat = inner ? 3 : 5
        let triangleLength: CGFloat = inner ? 0.15 : 0.2
        let color = inner ? UIColor.white.cgColor : Colors.brand.cgColor
        let offset: CGFloat = inner ? 1.5 : 0
        
        let trianglePath = UIBezierPath()
        let triangleBottom = circleView.frame.midY + (circleViewDiameter / 4)
        trianglePath.move(to: CGPoint(x: frame.midX - (triangleLength * circleViewDiameter), y: triangleBottom))
        trianglePath.addLine(to: CGPoint(x: frame.midX + (triangleLength * circleViewDiameter), y: triangleBottom))
        trianglePath.addLine(to: CGPoint(x: frame.midX , y: circleView.frame.midY + (0.55 * circleViewDiameter) - offset))
        trianglePath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = trianglePath.cgPath
        shapeLayer.fillColor = color
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = desiredLineWidth
        
        return shapeLayer
    }
    
    internal func drawCircle(diameter: CGFloat, color: CGColor) -> CAShapeLayer {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: circleView.frame.midX, y: circleView.frame.midY),
            radius: CGFloat(diameter / 2.0),
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        
        return shapeLayer
    }
    
    internal func setClicked(clicked: Bool) {
        self.clicked = clicked
    }
    
}

class EventMarker: LocationMarker {
    
    init() {
        super.init(markerType: .event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class SelectedEventMarker: LocationMarker {
    
    init() {
        super.init(markerType: .selectedEvent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class PlaceMarker: LocationMarker {
    
    init() {
        super.init(markerType: .place)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
