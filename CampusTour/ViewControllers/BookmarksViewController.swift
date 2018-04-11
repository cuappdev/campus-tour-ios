//
//  BookmarksViewController.swift
//  CampusTour
//
//  Created by Annie Cheng on 4/9/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private var firstLoad = true
    
    private var spec = ItemFeedSpec.getEventsDataSpec(headerInfo: nil, events: [])
    
    var events: [Event] = []
    private var delayCount = 0.0
    private let refreshControl = UIRefreshControl()
    
    func loadBookmarkedEvents() {
        let bookmarks = UserDefaults.standard.stringArray(forKey: "bookmarks") ?? []
        var tempEvents = [Event]()
        
        bookmarks.forEach { (id) in
            tempEvents.append(SearchHelper.getEventById(id, events: DataManager.sharedInstance.events)!)
        }
        
        events = tempEvents
    }
    
    func updateItems(newSpec: ItemFeedSpec) {
        self.spec = newSpec
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Bookmarked Events"
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView?.backgroundColor = .white
        tableView.estimatedRowHeight = 50
        tableView.insetsContentViewsToSafeArea = true
        tableView.alwaysBounceVertical = true
        tableView.refreshControl = refreshControl
        
        refreshControl.tintColor = Colors.brand
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        tableView.register(ItemOfInterestTableViewCell.self, forCellReuseIdentifier: ItemOfInterestTableViewCell.reuseIdEvent)
        
        loadBookmarkedEvents()
        spec = ItemFeedSpec.getMapEventsDataSpec(events: events)
        updateItems(newSpec: spec)
    }

    @objc func pullToRefresh() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension BookmarksViewController: ItemOfInterestCellDelegate {
    func updateBookmark(modelInfo: ItemOfInterestTableViewCell.ModelInfo) {
        BookmarkHelper.updateBookmark(id: modelInfo.id!)
        
        loadBookmarkedEvents()
        spec = ItemFeedSpec.getMapEventsDataSpec(events: events)
        updateItems(newSpec: spec)
    }
}

extension BookmarksViewController: DetailViewControllerDelegate {
    func updateBookmarkedCell() {
        tableView.reloadData()
    }
}

extension BookmarksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemOfInterestTableViewCell.reuseIdEvent) as! ItemOfInterestTableViewCell
        
        cell.setCellModel(model: events[indexPath.row].toItemFeedModelInfo(index: indexPath.row + 1))
        cell.delegate = self
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
            vc.delegate = self
            return vc
        }()
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch spec.sections[indexPath.section] {
        case _:
            if firstLoad {
                cell.animateUponLoad(delayCount: self.delayCount)
                delayCount += 1
            }
        }
        if indexPath.row > 4 || indexPath.row == events.count-1 {
            firstLoad = false
            return
        }
    }
}
