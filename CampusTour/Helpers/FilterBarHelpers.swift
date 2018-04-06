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

class FilterBar: UIView {
    
    var scrollView: UIScrollView!
    var selectedFilters = [Filter]()
    var buttons = [UIButton]()
    var bViews = [UIView]()
    private let padding = CGFloat(8)
    var delegate: FilterFunctionsDelegate?
    var filterBarCurrentStatus: FilterBarCurrentStatus = FilterBarCurrentStatus()
    
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

//            Change this so that it changes on selected
            button.backgroundColor = Colors.brand
            
//            let arrow = UIImageView(image: #imageLiteral(resourceName: "Triangle copy 2-1"))
//            arrow.contentMode = .scaleAspectFit
//            button.addSubview(arrow)
//            arrow.snp.makeConstraints({ (make) in
//                make.top.equalToSuperview().offset(padding)
//                make.height.equalTo(12)
//                make.trailing.equalToSuperview().offset(-padding)
//                make.width.equalTo(12)
//            })
            
            button.layer.cornerRadius = 4.0
            button.clipsToBounds = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.contentEdgeInsets = UIEdgeInsetsMake(0, padding, 0, padding)
            button.contentHorizontalAlignment = .left
//            button.setImage(#imageLiteral(resourceName: "Triangle copy 2-1"), for: .normal)
//            button.imageView?.contentMode = .scaleAspectFit
//            button.imageEdgeInsets = UIEdgeInsetsMake(0, (button.titleLabel?.intrinsicContentSize.width)! + padding*2, 0, padding)
//            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, padding*2+15)
            button.sizeToFit()
            button.addTarget(self, action: #selector(filterSelected(sender:)), for: .touchUpInside)
            
//            let bView = createButtonView(filter: filter)x4
//            button.addSubview(bView)
//            bView.snp.makeConstraints({ (make) in
//                make.edges.equalToSuperview()
//            })
            
            scrollView.addSubview(button)
            buttons.append(button)
//            bViews.append(bView)
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
        var filterMode: Filter
        filterBarCurrentStatus.generalSelected = (buttons.first?.title(for: .normal))!
        filterBarCurrentStatus.dateSelected = (buttons.last?.title(for: .normal))!
        switch selectedFilter {
        case .general:
            filterMode = .general
        case .date:
            filterMode = .date
        }
        let filterBarCenterX = sender.center.x
        
        let popupData = PopupData(filterBarStatus: filterBarCurrentStatus, filterMode: filterMode, filterBarLocationCenterX: filterBarCenterX)
        
        delegate?.openPopupView(popupData)
    }
    
//    func createButtonView(filter: Filter) -> UIView {
//        let bView = UIView()
//        
//        let textLabel = UILabel()
//        textLabel.text = filter.rawValue
//        textLabel.textColor = .white
//        textLabel.backgroundColor = Colors.brand
//        textLabel.font = UIFont.systemFont(ofSize: 16.0)
//        textLabel.sizeToFit()
//        
//        bView.addSubview(textLabel)
//        textLabel.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(padding)
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//        
//        let arrow = UIImageView(image: #imageLiteral(resourceName: "Triangle copy 2-1"))
//        arrow.contentMode = .scaleAspectFit
//        bView.addSubview(arrow)
//        arrow.snp.makeConstraints({ (make) in
//            make.top.equalToSuperview().offset(padding)
//            make.height.equalTo(12)
//            make.trailing.equalToSuperview().offset(-padding)
//            make.width.equalTo(12)
//            make.leading.equalTo(textLabel.snp.trailing)
//        })
//        arrow.backgroundColor = Colors.brand
//        arrow.isUserInteractionEnabled = false
//        
//        bView.backgroundColor = Colors.brand
//        bView.layer.cornerRadius = 4.0
//        
//        return bView
//    }
}

protocol FilterFunctionsDelegate {
    func openPopupView(_ type: PopupData) -> ()
}

protocol UpdateFilterProtocol {
    func updateFilter()
}
