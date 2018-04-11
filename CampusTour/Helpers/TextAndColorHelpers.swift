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
    
    static let paleGrey = rgbaInt(246, 247, 249, 1.0)
    
    static let brand = rgbaInt(206, 23, 69, 1.0)
    static let offwhite = rgbaInt(252, 252, 252, 1.0)
    static let shadow = rgbaInt(219, 219, 219, 0.5)
    static let systemBlue = rgbaInt(0, 118, 255, 1)
    static let rbgaInt = rgbaInt
}

enum Fonts {
    static let sectionHeaderFont = UIFont.systemFont(ofSize: 28, weight: .semibold)
    static let headerFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
    static let titleFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    static let subtitleFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let bodyFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let actionFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    static let markerFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
    static let tagFont = UIFont.systemFont(ofSize: 10, weight: .medium)
}

extension UILabel {
    static func label(text: String, color: UIColor = .black, font: UIFont = UIFont.systemFont(ofSize: 18)) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        return label
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }
}
