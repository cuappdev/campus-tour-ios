//
//  TopNavBar.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class TopNavBarTempVC: UIViewController, UISearchBarDelegate {
    
    var arButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arButton = UIBarButtonItem(title: "AR", style: .plain, target: self, action: #selector(openARMode))
        
        //Create searchbar
        searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.searchBarStyle = .default
        navigationItem.titleView = searchBar
        
    }
    
    @objc func openARMode() {
        //Open AR View
    }
    
    //SearchBar Delegates
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //Get results
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Remove search results
        searchBar.placeholder = "Search"
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //Start search
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Do search
    }
}
