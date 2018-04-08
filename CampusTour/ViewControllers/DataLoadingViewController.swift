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
            if success {
                self.hideLoadingIndicator()
                self.present(MainTabBarController(), animated: false, completion: nil)
            }
        }
    }
    
    func showLoadingIndicator() {
        loadingIndicator = LoadingIndicator()
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textColor = Colors.tertiary
        titleLabel.text = "Loading events and places..."
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
        
        var success = true
        let future = DataMultiTaskFuture {
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
        
        DataManager.sharedInstance.getEvents {
            success = success && $0
            future.notifyCompletion(task: .fetchEvents)
        }
        DataManager.sharedInstance.getLocations {
            success = success && $0
            future.notifyCompletion(task: .fetchLocations)
        }
    }

}
