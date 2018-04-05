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

/// temporary
struct Item {
    let title: String
    let date: Date
    let description: String
}

class ItemFeedViewController: UITableViewController {
    private let mapSection = 0, itemSection = 1, placesSection = 2
    
    var events: [Event] = testEvents
    let places: [Building] = testPlaces
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableHeaderView?.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 50
        tableView.insetsContentViewsToSafeArea = true
        tableView.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseIdEvent)
        tableView.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseIdPlace)
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.reuseId)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case mapSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.reuseId) as! MapTableViewCell
            cell.cellWillAppear()
            return cell
        case itemSection:
            let item = events[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemOfInterestTableViewCell.reuseIdEvent) as! ItemOfInterestTableViewCell
            cell.setCellModel(
                model: ItemOfInterestTableViewCell.ModelInfo(
                    title: item.name,
                    dateRange: (item.startTime, item.endTime),
                    description: item.description,
                    locationSpec: ItemOfInterestTableViewCell.LocationLineViewSpec(locationName: "todo, add location name",
                                                                                   distanceString: "x mi away") ,
                    tags: ["tag1", "tag2"], //TODO add tags to data
                    imageUrl: URL(string: "https://picsum.photos/150/150/?random")!),
                layout: .event)
            return cell
        case placesSection:
            let place = places[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemOfInterestTableViewCell.reuseIdPlace) as! ItemOfInterestTableViewCell
            cell.setCellModel(
                model: ItemOfInterestTableViewCell.ModelInfo(
                    title: place.name,
                    dateRange: nil,
                    description: place.department ?? "",
                    locationSpec: nil,
                    tags: ["tag1", "tag2"],
                    imageUrl: URL(string: "https://picsum.photos/150/150/?random")!) ,
                layout: .place)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case itemSection, placesSection:
            return UITableViewAutomaticDimension
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == itemSection || section == placesSection else {return nil}
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(
            UILabel.label(
                text: section == itemSection ? "EVENTS" : "ATTRACTIONS",
                color: Colors.tertiary,
                font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ))
        stack.addArrangedSubview(
            UILabel.label(
                text: section == placesSection ? "Discover" : "Explore",
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case mapSection:
            return
        case itemSection, placesSection:
            let item = events[indexPath.row]
            let detailVC: DetailViewController = {
                let vc = DetailViewController()
                vc.data = item
                return vc
            }()
            navigationController?.pushViewController(detailVC, animated: true)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case mapSection: return 140
        case itemSection, placesSection: return UITableViewAutomaticDimension
        default: return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case mapSection: return 1
        case itemSection: return events.count
        case placesSection: return places.count
        default: return 0
        }
    }
}
