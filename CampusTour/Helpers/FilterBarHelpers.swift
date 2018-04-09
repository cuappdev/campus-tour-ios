//
//  Filter.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/21/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

struct FilterBarCurrentStatus {
    var generalSelected: String
    var dateSelected: String
    
    init(_ gs: String = "General", _ ds: String = "Today") {
        generalSelected = gs
        dateSelected = ds
    }
}

enum Filter: String {
    case general = "General"
    case date = "Today"
}

fileprivate let filters: [Filter] = [
    .general,
    .date,
]

extension FeaturedViewController {
    
    func addFilterButton() {
        for (index, filter) in filters.enumerated() {
            let button = UIButton()
            
            button.setTitle(filter.rawValue, for: .normal)

            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(Colors.brand, for: .highlighted)
            
            button.backgroundColor = Colors.brand
            //TODO : Add white arrow :: harder than it seems
            button.layer.cornerRadius = 4.0
            button.clipsToBounds = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.contentEdgeInsets = UIEdgeInsetsMake(0, padding, 0, padding)
            button.contentHorizontalAlignment = .left
            button.addTarget(self, action: #selector(filterSelected(sender:)), for: .touchUpInside)
            button.sizeToFit()
            
            filterBarView.addSubview(button)
            buttons.append(button)
        }
        updateButtons()
    }
    
    func updateButtons() {
        for (index, button) in self.buttons.enumerated() {
            button.snp.updateConstraints({ (make) in
                if index == 0 {
                    make.leading.equalToSuperview().offset(padding)
                } else {
                    make.leading.equalTo(buttons[index-1].snp.trailing).offset(padding)
                }
                make.top.equalToSuperview().offset(padding)
                make.bottom.equalToSuperview().offset(padding)
                make.height.equalTo(28)
            })
        }
    }
    
    @objc func filterSelected(sender: UIButton) {
        let selectedFilter = filters[sender.tag]
        var filterMode: Filter
        switch selectedFilter {
        case .general:
            filterMode = .general
        case .date:
            filterMode = .date
        }
        let filterBarCenterX = sender.center.x
        
        let popupData = PopupData(filterBarStatus: filterBarCurrentStatus, filterMode: filterMode, filterBarLocationCenterX: filterBarCenterX)
        
        togglePopupView(popupData)
    }
}

extension UIImage {
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
