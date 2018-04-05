//
//  ItemFeedViewController.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 3/17/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import GoogleMaps

let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."

class ItemFeedViewController: UIViewController {
    
    private var spec = ItemFeedSpec(sections: [
        .map,
        .items(
            headerInfo: (title: "Explore", subtitle: "EVENTS"),
            items: testEvents,
            layout: .event
        ),
        .items(
            headerInfo: (title: "Discover", subtitle: "ATTRACTIONS"),
            items: testPlaces,
            layout: .place
        ),
    ])
    
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
    }
}

extension ItemFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch spec.sections[indexPath.section] {
        case .map:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.reuseId) as! MapTableViewCell
            cell.cellWillAppear()
            return cell
        case .items(_, let items, let layout):
            let item = items[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: layout.reuseId()) as! ItemOfInterestTableViewCell
            cell.setCellModel(model: item.toItemFeedModelInfo(), layout: layout)
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
        case .items(_, let items, _):
            return items.count
        }
    }
    
}

extension ItemFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch spec.sections[section] {
        case .items(_):
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
        case .items(_, let items, let layout):
            if layout == .place { return }
            let item = items[indexPath.row]
            let detailVC: DetailViewController = {
                let vc = DetailViewController()
                vc.event = item as! Event
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
