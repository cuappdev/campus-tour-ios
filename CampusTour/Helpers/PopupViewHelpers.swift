//
//  PopupViewHelpers.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/6/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

struct PopupData {
    var filterBarStatus: FilterBarCurrentStatus
    var filterMode: Filter
    var filterBarLocationCenterX: CGFloat
}

class TriangleView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        
        context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        context.fillPath()
    }
}
