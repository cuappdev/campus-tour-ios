//
//  FilterTableViewCell.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/5/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    let rootView = UIView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let checkImageView = UIImageView()
    var filterMode: Filter?

    struct FilterTableViewInfo {
        let maintitle: String
        let subtitle: String?
        
        static func generalTagToFilterTableView(tag: String) -> FilterTableViewInfo {
            return FilterTableViewInfo(maintitle: tag, subtitle: nil)
        }
        
        static func schoolTagToFilterTableView(tag: String, name: String) -> FilterTableViewInfo {
            return FilterTableViewInfo(maintitle: tag, subtitle: name)
        }
    }
    
    private let textInsetLarge = 16.5
    private let textInsetSmall = 12
    private let textPadding = 8.5
    
    func setupCell(_ info: FilterTableViewInfo, _ ischeckImageView: Bool = false) {
        backgroundColor = .white
        
        contentView.addSubview(rootView)
        
        rootView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        rootView.addSubview(titleLabel)
        rootView.addSubview(subtitleLabel)
        rootView.addSubview(checkImageView)
        
        checkImageView.image = #imageLiteral(resourceName: "CheckMark")
        checkImageView.contentMode = .scaleAspectFit
        checkImageView.clipsToBounds = true
       
        subtitleLabel.isHidden = true
        subtitleLabel.textColor = Colors.tertiary
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        //Set to checkmark
        if ischeckImageView {
            checkImageView.isHidden = false
        } else {
            checkImageView.isHidden = true
        }
        
        titleLabel.text = info.maintitle
        
        if let subtitleText = info.subtitle {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitleText
        }
        
        titleLabel.snp.updateConstraints { (make) in
            make.leading.equalToSuperview().offset(textInsetLarge)
            make.top.equalToSuperview().offset(textInsetSmall)
            make.bottom.equalToSuperview().offset(-textInsetSmall)
            make.width.equalTo(titleLabel.intrinsicContentSize.width)
        }
        subtitleLabel.snp.updateConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.trailing).offset(textPadding)
            make.top.equalTo(titleLabel.snp.top)
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.trailing.equalTo(checkImageView.snp.leading).offset(textInsetLarge)
        }
        checkImageView.snp.updateConstraints { (make) in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-textInsetLarge)
        }
    }
}
