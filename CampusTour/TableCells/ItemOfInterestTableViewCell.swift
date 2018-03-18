//
//  ItemOfInterestTableViewCell.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class ItemOfInterestTableViewCell: UITableViewCell {
    static let reuseId = "ItemOfInterestTableViewCell"
    
    struct Model {
        let title: String
        let date: Date
        let description: String
    }
    
    var rootStackView: UIStackView?
    
    func headerView(model: Model) -> UIView {
        let header = UIStackView()
        header.axis = .horizontal
        
        let titleLabel = UILabel()
        titleLabel.text = model.title
        header.addArrangedSubview(titleLabel)
        
        let dateLabel = UILabel()
        dateLabel.text = model.date.description //TODO format better
        header.addArrangedSubview(dateLabel)
        
        return header
    }
    
    func setCellModel(model: Model) {
        rootStackView?.removeFromSuperview()
        
        rootStackView = UIStackView()
        rootStackView?.axis = .vertical
        rootStackView?.addArrangedSubview(headerView(model: model))
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = model.description
        rootStackView?.addArrangedSubview(descriptionLabel)
        
        self.contentView.addSubview(rootStackView!)
        rootStackView?.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
