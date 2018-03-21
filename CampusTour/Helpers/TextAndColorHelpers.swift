//
//  TextAndColorHelpers.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/21/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

enum Colors {
    static let tertiary = UIColor.init(red: 144.0/255.0, green: 148.0/255.0, blue: 157.0/255.0, alpha: 1.0)
}

extension UILabel {
    static func label(text: String, color: UIColor = UIColor.black, font: UIFont = UIFont.systemFont(ofSize: 18)) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        return label
    }
}
