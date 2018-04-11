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

protocol FeaturedViewControllerDelegate {
    func didUpdateBookmarkFromFeaturedVC()
}

class FeaturedViewController: UIViewController {
    
    var delegate: FeaturedViewControllerDelegate!
    let itemFeedViewController = ItemFeedViewController()
    let poiMapViewController = POIMapViewController()
    let searchManager = ItemFeedSearchManager()
    
    var arButton: UIBarButtonItem!
    var viewTypeButton: UIBarButtonItem!
    var searchCancelButton: UIBarButtonItem!
    var viewType: ViewType!
    var tabBarHeight: CGFloat = 49
    
    private var blackView: UIView = {
        let bv = UIView()
        bv.backgroundColor = .black
        bv.alpha = 0
        bv.isUserInteractionEnabled = true
        return bv
    }()
    
    //Replace with data from DataManager
    var popupViewController: PopupViewController!
    private var currentModalMode: Filter?
    
    //Filterbar variables
    var filterBarView: UIScrollView!
    var selectedFilters = [Filter]()
    var buttons = [UIButton]()
    var filterBarCurrentStatus: FilterBarCurrentStatus = FilterBarCurrentStatus()
    
    //for popupViewController
    private var isModal = false {
        didSet {
            if !isModal {
                popupViewController.view.isHidden = true
                UIView.animate(withDuration: 0.6, animations: {
                    self.blackView.alpha = 0
                })
            } else {
                popupViewController.view.isHidden = false
                UIView.animate(withDuration: 0.4, animations: {
                    self.blackView.alpha = 0.7 })
            }
        }
    }
    
    //UIconstants
    let padding = CGFloat(8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //init search manager
        searchManager.delegate = self
        searchManager.allData = ItemFeedSpec.getMapEventsDataSpec().sections
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
        
        poiMapViewController.tabBarHeight = tabBarHeight
        
        setTopNavBar()
        setBottomView()
        
        view.addSubview(blackView)
        blackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.bringSubview(toFront: blackView)
  
        let touchView = UITapGestureRecognizer(target: self, action: #selector(closePopupView))
        blackView.addGestureRecognizer(touchView)
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
        let cancelButton = UIButton()
        cancelButton.setImage(#imageLiteral(resourceName: "ExitIconBrand"), for: .normal)
        //Kinda hacky way to max the X button work. Seems odd
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 14)
        cancelButton.addTarget(self, action: #selector(didEndSearchMode), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (make) in
            make.width.equalTo(38)
            make.height.equalTo(18)
        }
        searchCancelButton = UIBarButtonItem(customView: cancelButton)

        arButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ARIcon"), style: .plain, target: self, action: #selector(openARMode))
        navigationItem.setLeftBarButton(arButton, animated: false)
        
        viewTypeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "MapIcon"), style: .plain, target: self, action: #selector(toggleViewType))
        navigationItem.setRightBarButton(viewTypeButton, animated: false)

        filterBarView = UIScrollView()
        filterBarView.alwaysBounceHorizontal = true
        filterBarView.showsHorizontalScrollIndicator = false
        filterBarView.backgroundColor = navigationController?.navigationBar.barTintColor
        view.addSubview(filterBarView)
        filterBarView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        addFilterButton()
    }
    
    //Setup Feed portion of ViewController
    func setBottomView() {
        addChildViewController(itemFeedViewController)
        
        view.addSubview(itemFeedViewController.view)
        itemFeedViewController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        viewType = .List
        itemFeedViewController.delegate = self
        itemFeedViewController.didMove(toParentViewController: self)
    }
    
    func toggleVC(oldVC: UIViewController, newVC: UIViewController) {
        oldVC.willMove(toParentViewController: nil)
        addChildViewController(newVC)
        view.addSubview(newVC.view)
        
        if let nvc = newVC as? ItemFeedViewController { nvc.delegate = self }
        
        newVC.view.snp.remakeConstraints { make in
            make.top.equalTo(filterBarView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
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
        searchManager.searchBar.resignFirstResponder()
    }
    
    func togglePopupView(_ data: PopupData) {
        view.endEditing(true)
        
        popupViewController.resetVariables(status: filterBarCurrentStatus, filterMode: data.filterMode)
        popupViewController.data = data
        popupViewController.tableView.reloadData()
        
        view.bringSubview(toFront: blackView)
        view.bringSubview(toFront: popupViewController.view)
        
        var filterHeight = 0
        let maxScreenHeight = Int(UIScreen.main.bounds.height * 0.66)
        switch data.filterMode {
        case .general:
            filterHeight = min(maxScreenHeight, 40*Tag.schoolFilters.count+20)
            buttons.first?.bringSubview(toFront: blackView)
        case .date:
            filterHeight = min(maxScreenHeight, 40*Tag.allDates.count+20)
            buttons.first?.bringSubview(toFront: blackView)
        case .type:
            filterHeight = min(maxScreenHeight, 40*Tag.typeFilters.count+20)
            buttons.first?.bringSubview(toFront: blackView)
        case .specialInterest:
            filterHeight = min(maxScreenHeight, 40*Tag.specialInterestFilters.count + 20)
            buttons.first?.bringSubview(toFront: blackView)
        }
        self.popupViewController.view.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.filterBarView.snp.bottom).offset(10)
            make.height.equalTo(filterHeight)
        }
        self.popupViewController.remakeConstraints()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.popupViewController.view.layoutIfNeeded()
        }, completion: nil)
        searchManager.searchBar.resignFirstResponder()
        isModal = true
    }
    
    @objc func closePopupView() {
        isModal = false
        updateButtons()
        filterBarView.layoutIfNeeded()
        let filteredEvents = SearchHelper.getFilteredEvents(filterBarCurrentStatus)
        itemFeedViewController.updateItems(newSpec: ItemFeedSpec.getMapEventsDataSpec(events: filteredEvents))
        self.popupViewController.view.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    func setItemFeedDefaultSpec() {
        itemFeedViewController.updateItems(newSpec: ItemFeedSpec.getEventsDataSpec())
    }
    
    func setItemFeedSearchSpec() {
        itemFeedViewController.updateItems(newSpec: ItemFeedSpec.getEventsDataSpec(headerInfo: nil, events: []))
    }
}

extension FeaturedViewController: PopupFilterProtocol {
    func updateFilterBar(_ status: FilterBarCurrentStatus) {
        filterBarCurrentStatus = status
        closePopupView()
    }
}

extension FeaturedViewController: ItemFeedViewControllerDelegate {
    func didUpdateBookmark() {
        delegate.didUpdateBookmarkFromFeaturedVC()
    }
}


extension FeaturedViewController: ItemFeedSearchManagerDelegate {
    func didStartSearchMode() {
        setItemFeedSearchSpec()
        
        //Prepare filter viewcontroller
        addChildViewController(popupViewController)
        view.addSubview(popupViewController.view)
        popupViewController.view.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(filterBarView.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        popupViewController.remakeConstraints()
        
        isModal = false
        
        //Show filter bar
        filterBarView.isHidden = false
        filterBarView.snp.remakeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        //update nav bar
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 8
        navigationItem.leftBarButtonItems = [searchCancelButton]
        print("START search")
        
        let currVC = (viewType == .List) ? itemFeedViewController : poiMapViewController
        currVC.view.snp.remakeConstraints { make in
            make.top.equalTo(filterBarView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        popupViewController.removeFromParentViewController()
        navigationController?.navigationBar.layoutIfNeeded()
        searchManager.searchBar.layoutIfNeeded()
        isModal = false
        updateButtons()
    }
    
    func didFindSearchResults(results: ItemFeedSpec) {
        if self.searchManager.searchIsActive {
            self.itemFeedViewController.updateItems(newSpec: results)
        }
    }
    
    @objc func didEndSearchMode() {
        print("END search")

        //remove filter bar
        self.filterBarView.snp.remakeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let currVC = (viewType == .List) ? itemFeedViewController : poiMapViewController
        currVC.view.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(
            withDuration: 0.5,
            animations: {self.view.layoutIfNeeded()},
            completion: {_ in
                self.filterBarView.isHidden = true
                self.updateButtons()
        })
        
        //update nav bar
        navigationItem.setLeftBarButton(arButton, animated: false)
        
        //remove popup viewcontroller
        popupViewController.removeFromParentViewController()
        isModal = false
        
        searchManager.searchBar.resignFirstResponder()
        
        filterBarCurrentStatus = FilterBarCurrentStatus()
        setItemFeedDefaultSpec()
    }
    
    func returnFilterBarStatus() -> FilterBarCurrentStatus {
        return filterBarCurrentStatus
    }
}
