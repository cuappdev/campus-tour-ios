//
//  ItemOfInterestTableViewCell.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import SwiftDate
import Alamofire
import AlamofireImage

class ItemOfInterestTableViewCell: UITableViewCell {
    static let reuseIdEvent = "ItemOfInterestTableViewCell.event"
    static let reuseIdPlace = "ItemOfInterestTableViewCell.place"
    
    enum Layout {
        case event, place
        
        func reuseId() -> String {
            switch self {
            case .event: return ItemOfInterestTableViewCell.reuseIdEvent
            case .place: return ItemOfInterestTableViewCell.reuseIdPlace
            }
        }
    }
    
    struct ModelInfo {
        let index: Int?
        let title: String
        let dateRange: (Date, Date)?
        let description: String
        let locationSpec: LocationLineViewSpec?
        let tags: [String]
        let imageUrl: URL
        let layout: Layout
    }
    
    struct LocationLineViewSpec {
        let locationName: String
        let distanceString: String
    }
    
    var currentLayout: Layout?
    var separatorView: UIView?
    var rootStackView: UIStackView?
    var itemImageView: UIImageView?
    var dateLabel: UILabel?
    var titleLabel: UILabel?
    var locationLabel: UILabel?
    var tagView: TagView?
    var wantedImageUrl: URL?
    
    func titleHeaderView(model: ModelInfo) -> UIView {
        let header = UIStackView()
        header.axis = .horizontal
        
        let titleLabel = UILabel.label(text: model.title,
                                       color: Colors.primary,
                                       font: UIFont.systemFont(ofSize: 16, weight: .semibold))
        header.addArrangedSubview(titleLabel)
        
        return header
    }
    
    func locationLineView(spec: LocationLineViewSpec) -> (UIView, UILabel) {
        let hStack = UIStackView()
        hStack.spacing = 8
        hStack.axis = .horizontal
        let label = UILabel.label(
            text: spec.locationName,
            color: Colors.secondary,
            font: UIFont.systemFont(ofSize: 14))
        hStack.addArrangedSubview(label)
        return (hStack, label)
    }
    
    func createLeftStackView(layout: Layout) -> UIStackView {
        let leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.spacing = 8
        
        //add date label
        if layout == .event {
            dateLabel = UILabel.label(
                text: "",
                color: Colors.brand,
                font: UIFont.systemFont(ofSize: 12, weight: .medium))
            leftStackView.addArrangedSubview(dateLabel!)
        }
        
        //add the title header
        titleLabel = UILabel.label(
            text: "",
            color: Colors.primary,
            font: UIFont.boldSystemFont(ofSize: 16))
        leftStackView.addArrangedSubview(titleLabel!)
        
        //add location line
        if layout == .event {
            locationLabel = UILabel.label(text: "",
                                      color: Colors.primary,
                                      font: UIFont.systemFont(ofSize: 14))
            leftStackView.addArrangedSubview(locationLabel!)
        }
        
        tagView = TagView(tags: [])
        leftStackView.addArrangedSubview(tagView!)
        tagView?.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        return leftStackView
    }
    
    func createRightView(layout: Layout) -> UIView {
        let rightView = UIStackView()
        rightView.axis = .vertical
        
        itemImageView = UIImageView()
        imageView?.contentMode = .scaleAspectFill
        itemImageView?.layer.cornerRadius = 8
        itemImageView?.clipsToBounds = true
        itemImageView?.snp.makeConstraints { make in
            make.width.equalTo(84)
            make.height.equalTo(48)
        }
        rightView.addArrangedSubview(itemImageView!)
        
        rightView.addArrangedSubview(UIView())
        
        return rightView
    }
    
    func setUpViewsIfNecessary(layout: Layout) {
        if self.currentLayout == layout { return }
        
        rootStackView?.removeFromSuperview()
        rootStackView = UIStackView()
        rootStackView?.axis = .horizontal
        
        let leftStack = createLeftStackView(layout: layout)
        let rightView = createRightView(layout: layout)
        
        rootStackView?.addArrangedSubview(leftStack)
        rootStackView?.addArrangedSubview(rightView)
        
        self.contentView.addSubview(rootStackView!)
        rootStackView?.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        self.currentLayout = layout
        
        if separatorView == nil {
            separatorView = SeparatorView()
            self.contentView.addSubview(separatorView!)
            separatorView!.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    func setCellModel(model: ModelInfo) {
        let layout = model.layout
        setUpViewsIfNecessary(layout: layout)
        
        if let dateRange = model.dateRange {
            self.dateLabel?.text = DateHelper.getLongDate(startDate: dateRange.0, endDate: dateRange.1)
        } else {
            self.dateLabel?.text = ""
        }
        
        let prefix = (model.index != nil) ? "\(model.index!). " : ""
        self.titleLabel?.text = "\(prefix)\(model.title)"
        self.locationLabel?.text = model.locationSpec?.locationName ?? ""
        
        self.tagView?.set(tags: model.tags)
        
        //get image
        self.imageView?.image = nil
        self.wantedImageUrl = model.imageUrl
        self.itemImageView?.af_setImage(withURL: model.imageUrl)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
