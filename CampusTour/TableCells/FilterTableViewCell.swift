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
    let checked = UIImageView()
    var isToday: Bool = false
    var filterMode: Filter?
    
    private let textInsetLarge = 16.5
    private let textInsetSmall = 12
    private let textPadding = 8.5
    
    struct Info {
        let school: (String, String)?
        let date: String?
    }
    
    func setupCell(_ info: Info, _ isChecked: Bool = false) {
        backgroundColor = .white
        
        contentView.addSubview(rootView)
        
        rootView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        rootView.addSubview(titleLabel)
        rootView.addSubview(subtitleLabel)
        rootView.addSubview(checked)
        
        //set to checkmark icon
        checked.backgroundColor = .blue
        checked.contentMode = .scaleAspectFit
        checked.clipsToBounds = true
        
        if isToday {
            titleLabel.textColor = Colors.brand
            subtitleLabel.isHidden = true
        } else {
            titleLabel.textColor = Colors.primary
        }
        subtitleLabel.textColor = Colors.tertiary
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        //Set to checkmark
        if isChecked {
            checked.isHidden = false
        } else {
            checked.isHidden = true
        }
        
        switch filterMode {
        case .date?:
            subtitleLabel.isHidden = true
            titleLabel.text = info.date!
        case .general?:
            subtitleLabel.isHidden = false
            titleLabel.text = info.school!.0
            subtitleLabel.text = info.school!.1
        default: return
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
            make.trailing.equalTo(checked.snp.leading).offset(textInsetLarge)
        }
        checked.snp.updateConstraints { (make) in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(textInsetLarge)
        }
    }
}
