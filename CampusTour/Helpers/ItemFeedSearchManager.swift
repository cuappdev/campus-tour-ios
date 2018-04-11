//
//  ItemFeedSearchManager.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 4/6/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

protocol ItemFeedSearchManagerDelegate: class {
    func didStartSearchMode()
    func didFindSearchResults(results: ItemFeedSpec)
    func didEndSearchMode()
    func returnFilterBarStatus() -> FilterBarCurrentStatus
}

class ItemFeedSearchManager: NSObject, UISearchBarDelegate {
    weak var delegate: ItemFeedSearchManagerDelegate?
    
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
    
    //**** MARK ****
    //Connecting to another viewcontroller
    func attachTo(navigationItem: UINavigationItem) {
        navigationItem.titleView = searchBar
    }
    
    func detachFrom(navigationItem: UINavigationItem) {
        if navigationItem.titleView == searchBar {
            navigationItem.titleView = nil
        }
    }
    
    //**** MARK ****
    //Handle search functionality
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.placeholder = "Search"
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: false)
        searchBar.text = ""
        
        self.searchIsActive = false
        self.delegate?.didEndSearchMode()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //UI elements
        searchBar.setShowsCancelButton(false, animated: false)
        print("Text begin editing")
        self.searchIsActive = true
        searchBar.layoutIfNeeded()
        delegate?.didStartSearchMode()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //update search results
        let lowercaseText = searchBar.text?.lowercased() ?? ""
        var data: [Any]
        if let filterBarStatus = delegate?.returnFilterBarStatus() {
            data = SearchHelper.getFilteredEvents(filterBarStatus)
        } else {
            print("Shouldn't happen")
            return
        }
        var filteredItems: [ItemCellModelInfoConvertible]!
        var itemFeedSpec = ItemFeedSpec.getEventsDataSpec(headerInfo: nil, events: [])
        
        //Search returns nothing without this if
        if lowercaseText != "" {
            filteredItems = data.flatMap { dataElement -> ItemCellModelInfoConvertible? in
                switch dataElement {
                case let data as Event where
                    (data.name + data.description).lowercased().contains(lowercaseText):
                    return data
                default:
                    return nil
                }
            }
            
            if let items = filteredItems, items.count > 0 {
                itemFeedSpec = ItemFeedSpec.getMapEventsDataSpec(headerInfo: nil, events: items)
            }
        }
        
        self.delegate?.didFindSearchResults(results: itemFeedSpec)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

