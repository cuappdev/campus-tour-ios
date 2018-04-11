//
//  DataLoadingViewController.swift
//  CampusTour
//
//  Created by Annie Cheng on 4/7/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit

class DataLoadingViewController: UIViewController {
    
    var loadingIndicator: LoadingIndicator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingIndicator()

        loadEventsData { (success) in
            DispatchQueue.main.async {
                if success {
                    self.hideLoadingIndicator()
                    AppDelegate.shared?.window?.rootViewController = MainTabBarController()
                }
            }
        }
    }
    
    //MARK: Handle loading animation
    func showLoadingIndicator() {
        loadingIndicator = LoadingIndicator()
        
        let titleLabel = UILabel()
        titleLabel.font = Fonts.bodyFont
        titleLabel.textColor = Colors.tertiary
        titleLabel.text = "Loading events..."
        titleLabel.sizeToFit()
        
        view.addSubview(loadingIndicator!)
        view.addSubview(titleLabel)
        
        loadingIndicator!.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loadingIndicator!.snp.bottom).offset(10)
            make.centerX.equalTo(loadingIndicator!.snp.centerX)
        }
    }
    
    func hideLoadingIndicator() {
        loadingIndicator = nil
    }
    
    func loadEventsData(completion: @escaping ((_ success: Bool) -> Void)) {
        let success = true
        
        DataManager.sharedInstance.onDataFetchingComplete = {
            if success {
                let events = DataManager.sharedInstance.events
                print("Loaded \(events.count) events")
                
                completion(true)
            } else {
                let alertController = UIAlertController(title: "Uh oh!", message: "We're unable to fetch events at this time.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                completion(false)
            }
        }
        
        DataManager.sharedInstance.getEvents() {_ in }
        DataManager.sharedInstance.getLocations() {_ in}
    }

}
