//
//  MiscUIHelpers.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/21/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    static func insetWrapper(view: UIView, insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(insets.top)
            make.right.equalToSuperview().inset(insets.right)
            make.bottom.equalToSuperview().inset(insets.bottom)
            make.left.equalToSuperview().inset(insets.left)
        }
        return wrapper
    }
}

class SeparatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let (width, height) = (rect.width, rect.height)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        UIColor(white: 0.9, alpha: 1.0).setStroke()
        path.stroke()
    }
}
