//
//  ItemOfInterestTableViewCell.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

private func tagLabel(text: String) -> UILabel {
    let label = UILabel.label(text: text, color: Colors.tertiary)
    label.layer.cornerRadius = 4
    label.layer.borderColor = Colors.tertiary.cgColor
    label.layer.borderWidth = 1
    return label
}

private func tagsHStackView(tags: [String]) -> UIStackView {
    let hStack = UIStackView.fromList(views: tags.map(tagLabel))
    hStack.spacing = 4
    hStack.axis = .horizontal
    return hStack
}

private func formatDateRange(dates: (Date, Date)) -> String {
    //TODO make format better
    return "\(dates.0) - \(dates.1)"
}

class ItemOfInterestTableViewCell: UITableViewCell {
    static let reuseId = "ItemOfInterestTableViewCell"
    
    struct ModelInfo {
        let title: String
        let dateRange: (Date, Date)
        let description: String
        let locationSpec: LocationLineViewSpec
        let tags: [String]
    }
    
    struct LocationLineViewSpec {
        let locationName: String
        let distanceString: String
    }
    
    var rootStackView: UIStackView?
    
    func dateRangeView(model: ModelInfo) -> UIView {
        let label = UILabel()
        label.text = formatDateRange(dates: model.dateRange)
        return label
    }
    
    func titleHeaderView(model: ModelInfo) -> UIView {
        let header = UIStackView()
        header.axis = .horizontal
        
        let titleLabel = UILabel()
        titleLabel.text = model.title
        header.addArrangedSubview(titleLabel)
        
        return header
    }
    
    func locationLineView(spec: LocationLineViewSpec) -> UIView {
        let hStack = UIStackView()
        hStack.spacing = 8
        hStack.axis = .horizontal
        hStack.addArrangedSubview(UILabel.label(text: spec.locationName, color: UIColor.black))
        hStack.addArrangedSubview(UILabel.label(text: spec.distanceString, color: UIColor.black))
        return hStack
    }
    
    func setCellModel(model: ModelInfo) {
        rootStackView?.removeFromSuperview()
        
        rootStackView = UIStackView()
        rootStackView?.axis = .vertical
        
        //add date label
        rootStackView?.addArrangedSubview({
            let label = UILabel()
            label.text = formatDateRange(dates: model.dateRange)
            return label
        }())
        
        //add the title header
        rootStackView?.addArrangedSubview(titleHeaderView(model: model))
        
        //add location line
        rootStackView?.addArrangedSubview(locationLineView(spec: model.locationSpec))
        
        rootStackView?.addArrangedSubview(tagsHStackView(tags: model.tags))
        
        self.contentView.addSubview(rootStackView!)
        rootStackView?.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
