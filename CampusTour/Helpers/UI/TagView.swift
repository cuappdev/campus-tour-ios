//
//  TagView.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 4/9/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

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

///Class showing tags. Must initialize with init(tags: _)
class TagView: UIView {
    private var hStackView: UIStackView? = nil
    
    convenience init(tags: [String]) {
        self.init()
        
        let hStack = tagsHStackView(tags: tags)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.left.equalToSuperview()
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {$0.edges.equalToSuperview()}
        
        hStackView = hStack
    }
    
    func set(tags: [String]) {
        self.hStackView?.arrangedSubviews.forEach{$0.removeFromSuperview()}
        tags.map(tagLabel).forEach{self.hStackView?.addArrangedSubview($0)}
    }
}
