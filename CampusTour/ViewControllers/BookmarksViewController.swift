//
//  BookmarksViewController.swift
//  CampusTour
//
//  Created by Annie Cheng on 4/9/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    private var tableView: UITableView {
        return self.view as! UITableView
    }
    
    private var firstLoad = true
    
    private var spec = ItemFeedSpec.getEventsDataSpec(headerInfo: nil, events: [])
    
    var events: [Event] = []
    
    func loadBookmarkedEvents() {
        // TODO
        tableView.reloadData()
    }
    
    func updateItems(newSpec: ItemFeedSpec) {
        self.spec = newSpec
        tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView?.backgroundColor = .white
        tableView.estimatedRowHeight = 50
        tableView.insetsContentViewsToSafeArea = true
        
        tableView.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseIdEvent)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Bookmarked Events"
    }

}

extension BookmarksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemOfInterestTableViewCell.reuseIdEvent) as! ItemOfInterestTableViewCell
        
        cell.setCellModel(model: events[indexPath.row].toItemFeedModelInfo())
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
}

extension BookmarksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedEvent = events[indexPath.row]
        
        let detailVC: DetailViewController = {
            let vc = DetailViewController()
            vc.event = selectedEvent
            vc.title = selectedEvent.name
            return vc
        }()
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > 4 {
            firstLoad = false
            return
        }
        switch spec.sections[indexPath.section] {
        case _:
            if firstLoad {
                cell.animateUponLoad()
            }
        }
    }
    
}
