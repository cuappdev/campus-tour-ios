//
//  Filter.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/21/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

enum Filter: String {
    case Sort = "Sort"
    case College = "College"
    case Food = "Food"
    case Event = "Event"
    case Tour = "Tour"
}

fileprivate let filters: [Filter] = [
    .Sort,
    .College,
    .Food,
    .Event,
    .Tour,
]

class FilterBar: UIView {
    
    var scrollView: UIScrollView!
    var selectedFilters = [Filter]()
    private var buttons = [UIButton]()
    private let padding: CGFloat = 8.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .lightGray
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        addFilterButton()
    }
    
    func addFilterButton() {
        for (index, filter) in filters.enumerated() {
            let button = UIButton()
            button.setTitle(filter.rawValue, for: .normal)
            
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(UIColor.tourMainColor, for: .selected)
            
            //Change this so that it changes on selected
            button.backgroundColor = UIColor.tourMainColor
            
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
        switch selectedFilter {
        case .Sort:
            openModalFilterView(type: selectedFilter.rawValue)
        case .College:
            openModalFilterView(type: selectedFilter.rawValue)
        default:
            if self.selectedFilters.contains(selectedFilter) {
                self.selectedFilters = self.selectedFilters.filter{$0 != selectedFilter}
            } else {
                self.selectedFilters.append(selectedFilter)
            }
        }
    }
    
    func openModalFilterView(type: String) {
        //Functionality for adding modal filter view
    }
}

protocol UpdateFilterProtocol {
    func updateFilter()
}
