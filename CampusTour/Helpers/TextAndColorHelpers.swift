//
//  TextAndColorHelpers.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/21/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

private func rgbaInt(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
}

enum Colors {
    static let primary = rgbaInt(34, 34, 34, 1.0)
    static let secondary = rgbaInt(74, 74, 74, 0.8)
    static let tertiary = rgbaInt(144, 148, 157, 1.0)
    static let brand = rgbaInt(206, 23, 69, 1.0)
    static let offwhite = rgbaInt(252, 252, 252, 1.0)
    static let shadow = rgbaInt(219, 219, 219, 0.5)
    static let systemBlue = rgbaInt(0, 118, 255, 1)
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
