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
}

enum Filter: String {
    case general = "General"
    case date = "Date"
}

fileprivate let filters: [Filter] = [
    .general,
    .date,
]

class FilterBar: UIView {
    
    var scrollView: UIScrollView!
    var selectedFilters = [Filter]()
    var buttons = [UIButton]()
    private let padding = CGFloat(8)
    var delegate: FilterFunctionsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView()
        scrollView.backgroundColor = Colors.offwhite
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addFilterButton()
    }
    
    func addFilterButton() {
        for (index, filter) in filters.enumerated() {
            let button = UIButton()
            button.setTitle(filter.rawValue, for: .normal)
            
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(Colors.brand, for: .highlighted)
            
            //Change this so that it changes on selected
            button.backgroundColor = Colors.brand
            
            button.layer.cornerRadius = 4.0
            button.clipsToBounds = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.sizeToFit()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.contentEdgeInsets = UIEdgeInsetsMake(0, padding*2, 0, padding*2)
            
            button.addTarget(self, action: #selector(filterSelected(sender:)), for: .touchUpInside)
            
            scrollView.addSubview(button)
            buttons.append(button)
            button.snp.makeConstraints({ (make) in
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func filterSelected(sender: UIButton) {
        let selectedFilter = filters[sender.tag]
        var generalSelected: String?
        var dateSelected: String?
        var filterMode: Filter
        switch selectedFilter {
        case .general:
            generalSelected = selectedFilter.rawValue
            filterMode = .general
        case .date:
            dateSelected = sender.title(for: .normal)
            filterMode = .date
        }
        let filterBarCenterX = sender.center.x
        
        let popupData = PopupData(generalSelected: generalSelected, dateSelected: dateSelected, filterMode: filterMode, filterBarLocationCenterX: filterBarCenterX)
        
        delegate?.openPopupView(popupData)
    }
}

protocol FilterFunctionsDelegate {
    func openPopupView(_ type: PopupData) -> ()
}

protocol UpdateFilterProtocol {
    func updateFilter()
}
