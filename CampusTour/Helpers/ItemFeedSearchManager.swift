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

