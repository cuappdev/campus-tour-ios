//
//  TopNavBar.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterFunctionsDelegate, PopupFilterProtocol {
    
    var searchBar: UISearchBar!
    var searchResultsTableView: UITableView!
    let itemFeedViewController = ItemFeedViewController()
    var filterBar: FilterBar!
    var arButton: UIBarButtonItem!
    
    //Replace with data from DataManager
    let allData = [Any]()
    var popupViewController: PopupViewController!
    private let cellReuse = "reuse"
    private var currentModalMode: Filter?
    private var filterBarCurrentStatus = FilterBarCurrentStatus(Filter.general.rawValue, Filter.date.rawValue)
    private var blackView: UIView!
    
    private var isModal = false {
        didSet {
            if !isModal {
                popupViewController.view.isHidden = true
                blackView.isHidden = true
            } else {
                popupViewController.view.isHidden = false
                blackView.isHidden = false
            }
        }
    }
    var searchResult: [Any] = [] {
        didSet {
            searchResultsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        popupViewController = PopupViewController()
        popupViewController.delegate = self
        
        setTopNavBar()
        setBottomView()
        
        blackView = UIView(frame: view.bounds)
        blackView.backgroundColor = .black
        blackView.alpha = 0.3
//        view.insertSubview(blackView, aboveSubview: searchResultsTableView)
//        blackView.snp.makeConstraints{$0.edges.equalToSuperview()}
        blackView.isHidden = true
        view.bringSubview(toFront: filterBar)
    }
    
    @IBAction func openARMode() {
        let popupViewController = ARExplorerViewController.withDefaultData()
        self.present(popupViewController, animated: true, completion: nil)
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
            self.filterBar.buttons.first?.setTitle(self.filterBarCurrentStatus.generalSelected, for: .normal)
            self.filterBar.buttons.last?.setTitle(self.filterBarCurrentStatus.dateSelected, for: .normal)
            searchBar.becomeFirstResponder()
            return
        }
        popupViewController.resetVariables(status: filterBarCurrentStatus, filterMode: data.filterMode)
        popupViewController.data = data
        popupViewController.tableView.reloadData()
        
        view.bringSubview(toFront: popupViewController.view)
        
        var filterHeight = 0
        switch data.filterMode {
        case .general:
            filterHeight = min(320, 40*Tag.schoolFilters.count+20)
            filterBar.buttons.first?.bringSubview(toFront: blackView)
        case .date:
            filterHeight = min(320, 40*dateFilters.count+20)
            filterBar.buttons.first?.bringSubview(toFront: blackView)
        }
        
        popupViewController.view.snp.updateConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(filterBar.snp.bottom).offset(10)
            make.height.equalTo(filterHeight)
        }
        popupViewController.updateViewConstraints()
        popupViewController.view.becomeFirstResponder()
        searchBar.resignFirstResponder()
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
        filterBarCurrentStatus = status
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.placeholder = "Search"
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: false)
        navigationItem.setRightBarButton(arButton, animated: false)
        searchResultsTableView.isHidden = true
        filterBar.snp.remakeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        popupViewController.removeFromParentViewController()
        searchResult = [Any]()
        isModal = false
        filterBar.buttons.first?.setTitle(Filter.general.rawValue, for: .normal)
        filterBar.buttons.last?.setTitle(Filter.date.rawValue, for: .normal)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        getSearchResults(searchText: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //UI elements
        navigationItem.setRightBarButton(nil, animated: false)
        searchBar.setShowsCancelButton(true, animated: false)
        searchResultsTableView.isHidden = false
        filterBar.snp.remakeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        //Preparing filter viewcontroller
        addChildViewController(popupViewController)
        view.addSubview(popupViewController.view)
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
}
