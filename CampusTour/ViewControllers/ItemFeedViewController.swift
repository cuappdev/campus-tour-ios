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
    let mapSection = 0, itemSection = 1
    
    let items: [Item] = [
        Item(title: "Test", date: Date(), description: loremIpsum),
        Item(title: "Hello", date: Date(), description: loremIpsum),
        Item(title: "Hi", date: Date(), description: loremIpsum)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseId)
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.reuseId)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // google maps
            let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.reuseId) as! MapTableViewCell
            cell.cellWillAppear()
            return cell
        case 1: // item of interest
            let item = items[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemOfInterestTableViewCell.reuseId) as! ItemOfInterestTableViewCell
            cell.setCellModel(model:
                ItemOfInterestTableViewCell.Model(
                    title: item.title,
                    date: item.date,
                    description: item.description))
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case mapSection: return 140
        case itemSection: return 60
        default: return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case mapSection: return 1
        case itemSection: return items.count
        default: return 0
        }
    }
}
