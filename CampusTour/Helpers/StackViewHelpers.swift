//
//  StackViewHelpers.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/21/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

extension UIStackView {
    static func fromList(views: [UIView]) -> UIStackView {
        let stack = UIStackView()
        views.forEach {stack.addArrangedSubview($0)}
        return stack
    }
}
