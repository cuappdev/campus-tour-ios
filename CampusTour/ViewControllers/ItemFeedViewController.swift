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

let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."

class ItemFeedViewController: UIViewController {
    
    var loadingIndicator: UIView!
    var currentlySearching: Bool = false
    var events: [Event] = []
    
    private var spec = ItemFeedSpec(sections: [])
    
    private var tableView: UITableView {
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
        tableView.tableHeaderView?.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 50
        tableView.insetsContentViewsToSafeArea = true
        
        tableView.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseIdEvent)
        tableView.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseIdPlace)
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.reuseId)
        
        setupEmptyDataSet()
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
            let itemModel = items[indexPath.row].toItemFeedModelInfo()
            let cell = tableView.dequeueReusableCell(withIdentifier: itemModel.layout.reuseId()) as! ItemOfInterestTableViewCell
            cell.setCellModel(model: itemModel)
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
        headerView.backgroundColor = UIColor.white
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(
            UILabel.label(
                text: subtitle,
                color: Colors.tertiary,
                font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ))
        stack.addArrangedSubview(
            UILabel.label(
                text: title,
                color: Colors.primary,
                font: UIFont.systemFont(ofSize: 28, weight: .semibold)
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
        case .items(_, let items):
            
            guard let item = items[indexPath.row] as? Event else {
                return
            }
            
            let detailVC: DetailViewController = {
                let vc = DetailViewController()
                vc.event = item
                vc.title = item.toItemFeedModelInfo().title
                return vc
            }()
            
            navigationController?.pushViewController(detailVC, animated: true)
        default: return
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
        }  else {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "Triangle copy 2-1")) //TODO temporary "road" asset replacement - remove this
            imageView.contentMode = .scaleAspectFit
            symbolView = imageView
        }
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textColor = Colors.tertiary
        titleLabel.text = currentlySearching ? "Loading events and places..." : "Oops, there are no events or places that match your search!"
        titleLabel.sizeToFit()
        
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
        }
        
        return customView
    }
    
}
