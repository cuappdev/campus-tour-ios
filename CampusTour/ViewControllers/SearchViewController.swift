//
//  TopNavBar.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, FilterFunctionsDelegate, PopupFilterProtocol {
    
    let itemFeedViewController = ItemFeedViewController()
    var filterBar: FilterBar!
    var arButton: UIBarButtonItem!
    
    let searchManager = ItemFeedSearchManager()
    
    //Replace with data from DataManager
    var popupViewController: PopupViewController!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        popupViewController = PopupViewController()
        popupViewController.delegate = self
        
        setTopNavBar()
        setBottomView()
        
        blackView = UIView(frame: view.bounds)
        blackView.backgroundColor = .black
        blackView.alpha = 0.3
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
        
        //view.insertSubview(itemFeedViewController.view, belowSubview: searchResultsTableView)
        view.addSubview(itemFeedViewController.view)
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
        searchManager.delgate = self
        self.searchManager.attachTo(navigationItem: navigationItem)
        searchManager.allData = testEvents as [Any] + testPlaces as [Any]
        
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
    }
    
    
    func openPopupView(_ data: PopupData) {
        view.endEditing(true)
        if isModal {
            isModal = false
            self.filterBar.buttons.first?.setTitle(self.filterBarCurrentStatus.generalSelected, for: .normal)
            self.filterBar.buttons.last?.setTitle(self.filterBarCurrentStatus.dateSelected, for: .normal)
            searchManager.searchBar.becomeFirstResponder() //TODO encapsulate in searchManager
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
        searchManager.searchBar.resignFirstResponder()
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

extension SearchViewController: ItemFeedSearchManagerDelegate {
    func didStartSearchMode() {
        self.navigationItem.setRightBarButton(nil, animated: false)
        
        //Preparing filter viewcontroller
        addChildViewController(popupViewController)
        view.addSubview(popupViewController.view)
        isModal = false
    }

    func didFindSearchResults(results: ItemFeedSpec) {
        if self.searchManager.searchIsActive {
            self.itemFeedViewController.updateItems(newSpec: results)
        }
    }
    
    func didEndSearchMode() {
        popupViewController.removeFromParentViewController()
        isModal = false
        filterBar.buttons.first?.setTitle(Filter.general.rawValue, for: .normal)
        filterBar.buttons.last?.setTitle(Filter.date.rawValue, for: .normal)
        
        self.navigationItem.setRightBarButton(arButton, animated: false)
        self.itemFeedViewController.updateItems(newSpec: ItemFeedSpec.testItemFeedSpec)
    }
}

protocol ItemFeedSearchManagerDelegate: class {
    func didStartSearchMode()
    func didFindSearchResults(results: ItemFeedSpec)
    func didEndSearchMode()
}

class ItemFeedSearchManager: NSObject, UISearchBarDelegate {
    weak var delgate: ItemFeedSearchManagerDelegate?
    
    var allData = [Any]()
    var searchBar: UISearchBar
    private(set) var searchIsActive: Bool = false
    
    override init() {
        searchBar = UISearchBar()
        super.init()
        
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
    }
    
    func attachTo(navigationItem: UINavigationItem) {
        navigationItem.titleView = searchBar
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.placeholder = "Search"
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: false)
        
        self.delgate?.didEndSearchMode()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //UI elements
        searchBar.setShowsCancelButton(true, animated: false)
        
        self.searchIsActive = true
        delgate?.didStartSearchMode()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //update search results
        let lowercaseText = searchBar.text?.lowercased() ?? ""
        
        let filteredItems: [ItemCellModelInfoConvertible] = self.allData.flatMap { dataElement -> ItemCellModelInfoConvertible? in
            switch dataElement {
            case let data as Building where data.name.lowercased().contains(lowercaseText):
                return data
            case let data as Event where
                (data.name + data.description).lowercased().contains(lowercaseText):
                return data
            default:
                return nil
            }
        }
        
        let itemFeedSpec = ItemFeedSpec(sections: [
            .items(
                headerInfo: nil,
                items: filteredItems)
            ])
        
        self.delgate?.didFindSearchResults(results: itemFeedSpec)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("didEndEditing")
        searchBar.resignFirstResponder()
        searchBar.placeholder = "Search"
        searchBar.endEditing(true)
        self.searchIsActive = false
        delgate?.didEndSearchMode()
    }
}
