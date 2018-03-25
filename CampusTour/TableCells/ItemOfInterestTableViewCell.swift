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

private func formatDateRange(startDate start: Date, endDate end: Date) -> String {
    
    if start.isToday && end.isToday {
        return (start.isNight ? "TONIGHT" : "TODAY") + " " +
            start.string(custom: "HH:mm") + " " +
            end.string(custom: "HH:mm")
    }
    
    return "\(start.string(custom: "MM-dd"))"
}

/// Used to make updating UI more efficient
protocol UISpec {
    func toView() -> UIView
    func updateView(view: UIView) -> Bool
}

struct DateRangeUISpec: UISpec {
    let start: Date
    let end: Date
    
    @discardableResult
    func updateView(view: UIView) -> Bool {
        guard let label = view as? UILabel else {return false}
        label.text = formatDateRange(startDate: start, endDate: end)
        return true
    }
    
    func toView() -> UIView {
        let label = UILabel.label(text: "",
                                  color: Colors.brand, font: UIFont.systemFont(ofSize: 12, weight: .medium))
        updateView(view: label)
        return label
    }
    
    private func formatDateRange(startDate start: Date, endDate end: Date) -> String {
        if start.isToday && end.isToday {
            return "TODAY \(start.string(custom: "HH:mm")) - \(end.string(custom: "HH:mm"))"
        }
        
        return "\(start.string(custom: "MM-dd"))"
    }
}

private func tagLabel(text: String) -> UIView {
    let label = UILabel.label(text: text, color: Colors.tertiary, font: UIFont.systemFont(ofSize: 10, weight: .medium))
    let wrapper = UIView.insetWrapper(view: label, insets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    wrapper.layer.cornerRadius = 4
    wrapper.layer.borderColor = Colors.tertiary.cgColor
    wrapper.layer.borderWidth = 1
    return wrapper
}

private func tagsHStackView(tags: [String]) -> UIStackView {
    let hStack = UIStackView.fromList(views: tags.map(tagLabel))
    hStack.spacing = 4
    hStack.axis = .horizontal
    return hStack
}

class ItemOfInterestTableViewCell: UITableViewCell {
    static let reuseIdEvent = "ItemOfInterestTableViewCell.event"
    static let reuseIdPlace = "ItemOfInterestTableViewCell.place"
    
    enum Layout {
        case event, place
    }
    
    struct ModelInfo {
        let title: String
        let dateRange: (Date, Date)?
        let description: String
        let locationSpec: LocationLineViewSpec?
        let tags: [String]
        let imageUrl: URL
    }
    
    struct LocationLineViewSpec {
        let locationName: String
        let distanceString: String
    }
    
    var currentLayout: Layout?
    var rootStackView: UIStackView?
    var itemImageView: UIImageView?
    var dateLabel: UILabel?
    var titleLabel: UILabel?
    var locationLabel: UILabel?
    var tagsStackView: UIStackView?
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
        
        tagsStackView = tagsHStackView(tags: [])
        leftStackView.addArrangedSubview(tagsStackView!)
        
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
            make.edges.equalToSuperview().inset(8)
        }
        
        self.currentLayout = layout
    }
    
    func setCellModel(model: ModelInfo, layout: Layout) {
        setUpViewsIfNecessary(layout: layout)
        
        if let dateRange = model.dateRange {
            self.dateLabel?.text = formatDateRange(startDate: dateRange.0, endDate: dateRange.1)
        } else {
            self.dateLabel?.text = ""
        }
        
        self.titleLabel?.text = model.title
        self.locationLabel?.text = model.locationSpec?.locationName ?? ""
        
        self.tagsStackView?.arrangedSubviews.forEach {$0.removeFromSuperview()}
        model.tags.forEach {self.tagsStackView?.addArrangedSubview(tagLabel(text: $0))}
        
        //get image
        self.imageView?.image = nil
        self.wantedImageUrl = model.imageUrl
        Alamofire.request(model.imageUrl).responseImage { [weak self] response in
            if let image = response.result.value,
                model.imageUrl == self?.wantedImageUrl {
                DispatchQueue.main.async { [weak self] in
                    self?.itemImageView?.image = image
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
