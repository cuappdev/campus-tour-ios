//
//  TopNavBar.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FilterFunctionsDelegate {
    
    var searchBar: UISearchBar!
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
    
//    private let blackView: UIView = {
//        //To make screen go dark
//        let v = UIView()
//        v.backgroundColor = .black
//        v.alpha = 0
//        return v
//    }()
    
    private var isModal = false {
        didSet {
            if !isModal {
                popupViewController.view.isHidden = true
            } else {
                popupViewController.view.isHidden = false
            }
        }
    }
    
    private var currentModalMode: Filter?
    
    let popupViewController = PopupViewController()
    
    //create class containing all of our static data for tours, events, buildings
    let allData = [Any]()
    
    private var filterBarCurrentStatus = FilterBarCurrentStatus(generalSelected: Filter.general.rawValue, dateSelected: "today")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
//        let window = UIApplication.shared.keyWindow!
//        window.addSubview(blackView)
        
        setTopNavBar()
        setBottomView()
    }
    
    @IBAction func openARMode() {
        let popupViewController = ARExplorerViewController.withDefaultData()
        self.present(popupViewController, animated: true, completion: nil)
    }
    
    //SearchBar Delegates
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsTableView.isHidden = true
        filterBar.snp.remakeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        searchBar.resignFirstResponder()
        searchBar.placeholder = "Search"
        searchBar.endEditing(true)
        navigationItem.setRightBarButton(arButton, animated: false)
        searchBar.setShowsCancelButton(false, animated: false)
        popupViewController.removeFromParentViewController()
        searchResult = [Any]()
        isModal = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        getSearchResults(searchText: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.setRightBarButton(nil, animated: false)
        searchBar.setShowsCancelButton(true, animated: false)
        filterBar.snp.remakeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        addChildViewController(popupViewController)
        view.addSubview(popupViewController.view)
        searchResultsTableView.isHidden = false
        isModal = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //Search functionality
    private func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    private func getSearchResults(searchText: String) -> () {
        let lowercase = searchText.lowercased()
        self.searchResult = self.allData.filter({ (data) -> Bool in
            switch data {
            case let data as Building:
                return data.name.lowercased().contains(lowercase)
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
        
        itemFeedViewController.didMove(toParentViewController: self)
    }
    
    //Setup filter & search portion of ViewController
    func setTopNavBar() {
        //Create search
        searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        //seems dumb--will have to check on this
        for s in searchBar.subviews[0].subviews {
            if s is UITextField {
                s.layer.borderWidth = 1.0
                s.layer.borderColor = Colors.shadow.cgColor
                s.layer.cornerRadius = 10
            }
        }
        
        navigationItem.titleView = searchBar
        definesPresentationContext = false
        
        arButton = UIBarButtonItem(title: "AR", style: .plain, target: self, action: #selector(openARMode))
        navigationItem.setRightBarButton(arButton, animated: false)
        
        filterBar = FilterBar()
        filterBar.delegate = self
        view.addSubview(filterBar)
        filterBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        
        searchResultsTableView = UITableView()
        searchResultsTableView.backgroundColor = .white
        view.addSubview(searchResultsTableView)
        searchResultsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(filterBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        searchResultsTableView.backgroundColor = .lightGray
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.isHidden = true
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuse)
        searchResultsTableView.bounces = true
        searchResultsTableView.isUserInteractionEnabled = true
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
    
    func openPopupView(_ data: PopupData) {
        view.endEditing(true)
        if isModal {
            isModal = false
            return
        }
        
        popupViewController.data = data
        var filterHeight = 0
        switch data.filterMode {
        case .general:
            filterHeight = min(320, 40*Tag.schoolFilters.count+20)
        case .date:
            filterHeight = min(320, 40*dateFilters.count+20)
        }
        popupViewController.tableView.reloadData()
        popupViewController.view.snp.updateConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(filterBar.snp.bottom).offset(10)
            make.height.equalTo(filterHeight)
        }
        popupViewController.updateViewConstraints()
        popupViewController.view.becomeFirstResponder()
        isModal = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch called")
        guard let touch = touches.first else { return }
        print("iscalled")
        if isModal {
            let loc = touch.location(in: self.view)
            if !popupViewController.view.frame.contains(loc) {
                isModal = false
            }
        }
    }
    
    func updateFilterBar(_ status: FilterBarCurrentStatus) {
        filterBar.buttons.first?.setTitle(status.generalSelected, for: .normal)
        filterBar.buttons.last?.setTitle(status.dateSelected, for: .normal)
    }
}
