//
//  TopNavBar.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchController: UISearchController!
    var searchResultsTableView: UITableView!
    let itemFeedViewController = ItemFeedViewController()
    var filterBar: FilterBar!
    var arButton: UIBarButtonItem!
    var searchResult: [Any] = [] {
        didSet {
            searchResultsTableView.reloadData()
        }
    }
    private let cellReuse = "reuse"
    
    //create class containing all of our static data for tours, events, buildings
    let allData = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        setTopNavBar()
        setBottomView()
    }
    
    @objc func openARMode() {
        //TODO: Open AR View
    }
    
    //SearchBar Delegates
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Remove search results
        searchResult = [Any]()
        searchResultsTableView.isHidden = true
        searchBar.resignFirstResponder()
        searchBar.placeholder = "Search"
        searchBar.endEditing(true)
        navigationItem.setRightBarButton(arButton, animated: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchController.searchBar.text else { return }
        searchResultsTableView.isHidden = false
        getSearchResults(searchText: searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        navigationItem.setRightBarButton(nil, animated: false)
        searchBar.setShowsCancelButton(true, animated: true)
        searchResultsTableView.isHidden = false
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Unsure if necessary
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResult = [Any]()
        searchResultsTableView.isHidden = true
        searchBar.resignFirstResponder()
        searchBar.placeholder = "Search"
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        navigationItem.setRightBarButton(arButton, animated: false)
    }
    
    //Search functionality
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func getSearchResults(searchText: String) -> () {
        let lowercase = searchText.lowercased()
        self.searchResult = self.allData.filter({ (data) -> Bool in
            switch data {
            case let data as Building:
                return data.name.lowercased().contains(lowercase)
            case let data as Tour:
                return data.name.lowercased().contains(searchText) || data.description.lowercased().contains(searchText)
            case let data as Event:
                return data.name.lowercased().contains(searchText) || data.description.lowercased().contains(searchText)
            default:
                return false
            }
        })
    }
    
    //Setup Feed portion of ViewController
    func setBottomView() {
        addChildViewController(itemFeedViewController)
        
        view.insertSubview(itemFeedViewController.view, belowSubview: searchResultsTableView)
        itemFeedViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(filterBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //Setup filter & search portion of ViewController
    func setTopNavBar() {
        //Create search
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        //seems dumb--will have to check on this
        for s in searchController.searchBar.subviews[0].subviews {
            if s is UITextField {
                s.layer.borderWidth = 1.0
                s.layer.borderColor = Colors.shadow.cgColor
                s.layer.cornerRadius = 10
            }
        }
        
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = false
        
        
        arButton = UIBarButtonItem(title: "AR", style: .plain, target: self, action: #selector(openARMode))
        navigationItem.setRightBarButton(arButton, animated: false)
        
        filterBar = FilterBar()
        view.addSubview(filterBar)
        filterBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        searchResultsTableView = UITableView()
        searchResultsTableView.backgroundColor = .lightGray
        view.addSubview(searchResultsTableView)
        searchResultsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(filterBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.isHidden = true
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuse)
        searchResultsTableView.bounces = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Implement Serge's custom tableviewcells
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("cell tapped at \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
}
