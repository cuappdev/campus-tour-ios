//
//  ItemFeedViewController.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/17/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import GoogleMaps
import DZNEmptyDataSet

protocol ItemFeedViewControllerDelegate {
    func didUpdateBookmark()
}

class ItemFeedViewController: UIViewController {
    
    var loadingIndicator: UIView!
    var currentlySearching: Bool = false
    var delegate: ItemFeedViewControllerDelegate!
    
    private var spec = ItemFeedSpec(sections: [])
    
    private var firstLoad = true
    private var delayCount = 0.0
    
    var tableView: UITableView {
        return self.view as! UITableView
    }
    
    override func loadView() {
        self.view = UITableView()
    }
    
    func updateItems(newSpec: ItemFeedSpec) {
        self.spec = newSpec
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView?.backgroundColor = .white
        tableView.estimatedRowHeight = 50
        tableView.insetsContentViewsToSafeArea = true
        
        tableView.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseIdEvent)
        tableView.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseIdPlace)
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.reuseId)
        
        setupEmptyDataSet()
    }
    
}

extension ItemFeedViewController: ItemOfInterestCellDelegate {
    func updateBookmark(modelInfo: ItemOfInterestTableViewCell.ModelInfo) {
        BookmarkHelper.updateBookmark(id: modelInfo.id!)
        delegate.didUpdateBookmark()
        tableView.reloadRows(at: [IndexPath(row: modelInfo.index!-1, section: spec.sections.count-1)], with: .none)
        
    }
}

extension ItemFeedViewController: DetailViewControllerDelegate {
    func updateBookmarkedCell() {
        tableView.reloadData()
    }
}

extension ItemFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch spec.sections[indexPath.section] {
        case .map:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.reuseId) as! MapTableViewCell
            cell.cellWillAppear()
            return cell
        case .items(_, let items):
            let itemModel = items[indexPath.row].toItemFeedModelInfo(index: indexPath.row + 1)
            let cell = tableView.dequeueReusableCell(withIdentifier: itemModel.layout.reuseId()) as! ItemOfInterestTableViewCell
            cell.setCellModel(model: itemModel)
            cell.delegate = self
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return spec.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch spec.sections[section] {
        case .map:
            return 1
        case .items(_, let items):
            return items.count
        }
    }
}

extension ItemFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch spec.sections[section] {
        case .items(let headerInfo, _) where headerInfo != nil:
            return UITableViewAutomaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: String
        let subtitle: String
        switch spec.sections[section] {
        case .items(let item) where item.headerInfo != nil:
            title = item.headerInfo!.title
            subtitle = item.headerInfo!.subtitle
        default:
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(
            UILabel.label(
                text: subtitle,
                color: Colors.tertiary,
                font: Fonts.actionFont
        ))
        stack.addArrangedSubview(
            UILabel.label(
                text: title,
                color: Colors.primary,
                font: Fonts.sectionHeaderFont
        ))
        
        headerView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        let separatorView = SeparatorView()
        headerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch spec.sections[indexPath.section] {
        case .map:
            let parentVC = parent as! FeaturedViewController
            parentVC.toggleViewType()
        case .items(_, let items):
            
            guard let item = items[indexPath.row] as? Event else {
                return
            }
            
            let detailVC: DetailViewController = {
                let vc = DetailViewController()
                vc.event = item
                vc.title = item.toItemFeedModelInfo().title
                vc.delegate = self
                return vc
            }()
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch spec.sections[indexPath.section] {
        case .map:
            return 140
        case .items(_):
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > 4 {
            firstLoad = false
            return
        }
        switch spec.sections[indexPath.section] {
        case .map: return
        case _:
            if firstLoad {
                cell.animateUponLoad(delayCount: self.delayCount)
                delayCount += 1
            }
        }
    }
}

extension ItemFeedViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    private func setupEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.contentOffset = .zero
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        let customView = UIView()
        var symbolView = UIView()
        
        if currentlySearching {
            symbolView = LoadingIndicator()
        } else {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "SadEmojiIcon"))
            imageView.contentMode = .scaleAspectFit
            symbolView = imageView
        }
        
        let titleLabel = UILabel()
        titleLabel.font = Fonts.titleFont
        titleLabel.textColor = Colors.tertiary
        titleLabel.text = currentlySearching ? "Loading events..." : "Oops, there are no events that match your search!"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        customView.addSubview(symbolView)
        customView.addSubview(titleLabel)
        
        symbolView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(currentlySearching ? -20 : -22.5)
            make.width.equalTo(currentlySearching ? 40 : 45)
            make.height.equalTo(currentlySearching ? 40 : 45)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(symbolView.snp.bottom).offset(10)
            make.centerX.equalTo(symbolView.snp.centerX)
            make.width.lessThanOrEqualTo(250)
        }
        
        return customView
    }
    
}
