//
//  CircleCompositeView.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 4/13/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class CircleCompositeView: UIView {
    convenience init(child: UIView) {
        self.init()
        
        self.addSubview(child)
        child.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.width.equalTo(self.snp.height)
        }
        
        setCornerRadius()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    
    func setCornerRadius() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
