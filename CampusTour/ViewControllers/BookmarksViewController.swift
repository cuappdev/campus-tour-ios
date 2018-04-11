//
//  BookmarksViewController.swift
//  CampusTour
//
//  Created by Annie Cheng on 4/9/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

protocol BookmarksViewControllerDelegate {
    func didUpdateBookmarkFromBookmarkVC()
}

class BookmarksViewController: UIViewController {
    
    private var tableView: UITableView!
    var delegate: BookmarksViewControllerDelegate!
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
    
    func updateTableView() {
        loadBookmarkedEvents()
        spec = ItemFeedSpec.getMapEventsDataSpec(events: events)
        tableView.reloadData()
    }
    
    //Call init to prevent running into nil when calling tableView.reloadData before viewDidLoad
    init() {
        super.init(nibName: nil, bundle: nil)
        tableView = UITableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Bookmarked Events"
        
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
        
        updateTableView()
    }

    @objc func pullToRefresh() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

//**** MARK ****
//Custom view protocols
extension BookmarksViewController: ItemOfInterestCellDelegate {
    func updateBookmark(modelInfo: ItemOfInterestTableViewCell.ModelInfo) {
        BookmarkHelper.updateBookmark(id: modelInfo.id!)
        updateBookmarkedCell()
        updateTableView()
    }
}

extension BookmarksViewController: DetailViewControllerDelegate {
    func updateBookmarkedCell() {
        updateTableView()
        delegate.didUpdateBookmarkFromBookmarkVC()
    }
}


//**** MARK ****
//Tableview protocols
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
