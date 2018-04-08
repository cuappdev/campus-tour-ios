//
//  FeaturedViewController.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 3/18/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import SnapKit

enum ViewType {
    case List
    case Map
}

class FeaturedViewController: UIViewController, FilterFunctionsDelegate, PopupFilterProtocol {
    let itemFeedViewController = ItemFeedViewController()
    let poiMapViewController = POIMapViewController()
    var filterBar: FilterBar!
    var arButton: UIBarButtonItem!
    var viewTypeButton: UIBarButtonItem!
    var viewType: ViewType!
    let searchManager = ItemFeedSearchManager()
    
    //Replace with data from DataManager
    var popupViewController: PopupViewController!
    private var currentModalMode: Filter?
    private var filterBarCurrentStatus = FilterBarCurrentStatus(Filter.general.rawValue, Filter.date.rawValue)
    private var blackView: UIView!
    
    //for popupViewController
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
        
        extendedLayoutIncludesOpaqueBars = true
        
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //init search manager
        searchManager.delegate = self
        searchManager.allData = ItemFeedSpec.getSharedDataSpec().sections
            .reduce([]) { result, section in
                switch section {
                case .items(_, let items):
                    return result + (items as [Any])
                case .map:
                    return result
                }
        }
        
        setItemFeedDefaultSpec()
        
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
    
    @IBAction func toggleViewType() {
        if viewType == .List {
            viewType = .Map
            viewTypeButton.image = #imageLiteral(resourceName: "ListIcon")
            toggleVC(oldVC: itemFeedViewController, newVC: poiMapViewController)
        } else {
            viewType = .List
            viewTypeButton.image = #imageLiteral(resourceName: "MapIcon")
            toggleVC(oldVC: poiMapViewController, newVC: itemFeedViewController)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchManager.attachTo(navigationItem: navigationItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchManager.detachFrom(navigationItem: navigationItem)
    }
    
    //Setup filter & search portion of ViewController
    func setTopNavBar() {
        
//        arButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ARIcon"), style: .plain, target: self, action: #selector(openARMode))
//        navigationItem.setRightBarButton(arButton, animated: false)
        
        viewTypeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "MapIcon"), style: .plain, target: self, action: #selector(toggleViewType))
        navigationItem.setRightBarButton(viewTypeButton, animated: false)
        
        filterBar = FilterBar()
        filterBar.delegate = self
        filterBar.backgroundColor = navigationController?.navigationBar.barTintColor
        view.addSubview(filterBar)
        filterBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    //Setup Feed portion of ViewController
    func setBottomView() {
        addChildViewController(itemFeedViewController)
        
        //view.insertSubview(itemFeedViewController.view, belowSubview: searchResultsTableView)
        view.addSubview(itemFeedViewController.view)
        itemFeedViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        viewType = .List
        itemFeedViewController.didMove(toParentViewController: self)
    }
    
    func toggleVC(oldVC: UIViewController, newVC: UIViewController) {
        oldVC.willMove(toParentViewController: nil)
        addChildViewController(newVC)
        view.addSubview(newVC.view)
        newVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        newVC.view.alpha = 0
        newVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            newVC.view.alpha = 1
            oldVC.view.alpha = 0
        }, completion: { finished in
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParentViewController()
            newVC.didMove(toParentViewController: self)
        })
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
    
    func setItemFeedDefaultSpec() {
        itemFeedViewController.updateItems(newSpec: ItemFeedSpec.getSharedDataSpec())
    }

}

extension FeaturedViewController: ItemFeedSearchManagerDelegate {
    func didStartSearchMode() {
        print("START search")
        self.navigationItem.setRightBarButton(nil, animated: false)

        //Prepare filter viewcontroller
        addChildViewController(popupViewController)
        view.addSubview(popupViewController.view)
        isModal = false
        
        //Show filter bar
        filterBar.isHidden = false
        filterBar.snp.remakeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        itemFeedViewController.view.snp.remakeConstraints { make in
            make.top.equalTo(filterBar.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didFindSearchResults(results: ItemFeedSpec) {
        if self.searchManager.searchIsActive {
            self.itemFeedViewController.updateItems(newSpec: results)
        }
    }
    
    func didEndSearchMode() {
        print("END search")

        //remove filter bar
        self.filterBar.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        itemFeedViewController.view.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(
            withDuration: 0.5,
            animations: {self.view.layoutIfNeeded()},
            completion: {_ in self.filterBar.isHidden = true})
        
        //remove popup viewcontroller
        popupViewController.removeFromParentViewController()
        isModal = false
        filterBar.buttons.first?.setTitle(Filter.general.rawValue, for: .normal)
        filterBar.buttons.last?.setTitle(Filter.date.rawValue, for: .normal)
        
        self.navigationItem.setRightBarButton(arButton, animated: false)
        setItemFeedDefaultSpec()
    }
}
