//
//  TopNavBar.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

enum SearchResult {
    case Building(Building)
    case Event(Event)
    case Tour(Tour)
}

class TopNavBarTempVC: UIViewController {
    
    var searchController: UISearchController!
    var tableView: UITableView!
    var searchResult: [SearchResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTopNavBar()
    }
    
    @objc func openARMode() {
        //TODO: Open AR View
    }
    
    @objc func rightButtonFunction() {
        //TODO: Some functionality for the right button
    }
    
    //SearchBar Delegates
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //TODO
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Remove search results
        searchBar.placeholder = "Search"
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //TODO: Start search
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //TODO: search
    }
    
    //Search functionality
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func getSearchResults(searchText: String) -> [SearchResult] {
        return []
    }
    
    func setUI() {
        tableView = UITableView()
        //Use tableview from MainPage
    }
    
    func setTopNavBar() {
        //Create search
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let arButton = UIBarButtonItem(title: "AR", style: .plain, target: self, action: #selector(openARMode))
        let rightButton = UIBarButtonItem(title: "CU", style: .plain, target: self, action: #selector(rightButtonFunction))
        navigationItem.setRightBarButton(rightButton, animated: false)
        navigationItem.setLeftBarButton(arButton, animated: false)
        
        navigationItem.title = "Cornell App"
    }
 
}

//Extension for UISearch
extension TopNavBarTempVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //Implement
    }
}
