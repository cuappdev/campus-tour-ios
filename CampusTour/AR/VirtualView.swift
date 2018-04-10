//
//  VirtualViewBuilders.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 4/2/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import ARKit
import CoreLocation
import SnapKit

struct ARItemOfInterest {
    let name: String
    let location: CLLocation
}

class ARItemOfInterestView : UIView {
    var subtitleLabel: UILabel?
    
    func updateSubtitleWithDistance(meters: Double) {
        subtitleLabel?.text = String.init(format: "%.1f m", meters)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    convenience init(item: ARItemOfInterest) {
        let scaling = CGFloat(4.0)
        let width = UIScreen.main.bounds.width * scaling
        let height = width / 3
        
        self.init(frame:
            CGRect(x: 0, y: 0, width: width, height: height))
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        
        let wrapperView = UIView()
        wrapperView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        wrapperView.layer.cornerRadius = 10 * scaling
        wrapperView.clipsToBounds = true
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .center
        
        //no idea why but these views appear in reverse order
        subtitleLabel = UILabel.label(text: "Loading Location...",
                                      color: Colors.secondary,
                                      font: UIFont.systemFont(ofSize: 20 * scaling, weight: .medium))
        vStack.addArrangedSubview(subtitleLabel!)
        vStack.addArrangedSubview(UILabel.label(text: item.name,
                                                color: Colors.primary,
                                                font: UIFont.systemFont(ofSize: 24 * scaling, weight: .semibold)))
        
        wrapperView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16 * scaling)
        }
        
        self.addSubview(wrapperView)
        wrapperView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview()
            $0.height.lessThanOrEqualToSuperview()
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
