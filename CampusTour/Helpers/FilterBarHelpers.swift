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
    var schoolSelected: String
    var dateSelected: String
    var typeSelected: String
    var specialInterestSelected: String
    
    init(_ gs: String = "All Schools", _ ds: String = "All Dates", _ ts: String = "Type", _ sis: String = "Special Interest") {
        schoolSelected = gs
        dateSelected = ds
        typeSelected = ts
        specialInterestSelected = sis
    }
}

enum Filter: String {
    case general = "All Schools"
    case date = "All Dates"
    case type = "Type"
    case specialInterest = "Special Interest"
}

fileprivate let filters: [Filter] = [
    .general,
    .date,
    .type,
    .specialInterest
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
            switch index {
            case 0:
                button.setTitle(filterBarCurrentStatus.schoolSelected, for: .normal)
            case 1:
                button.setTitle(filterBarCurrentStatus.dateSelected, for: .normal)
            case 2:
                button.setTitle(filterBarCurrentStatus.typeSelected, for: .normal)
            case 3:
                button.setTitle(filterBarCurrentStatus.specialInterestSelected, for: .normal)
            default:
                continue
            }
        }
    }
    
    func resetButtons() {
        for (index, button) in self.buttons.enumerated() {
            switch index {
            case 0:
                button.setTitle("All Schools", for: .normal)
            case 1:
                button.setTitle("All Dates", for: .normal)
            case 2:
                button.setTitle("Type", for: .normal)
            case 3:
                button.setTitle("Special Interest", for: .normal)
            default:
                continue
            }
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
        case .type:
            filterMode = .type
        case .specialInterest:
            filterMode = .specialInterest
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
