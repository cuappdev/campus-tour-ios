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
                AppDelegate.shared?.window?.rootViewController = MainTabBarController()
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
        let events = DataManager.sharedInstance.events
        print("Loaded \(events.count) events")
        completion(true)
    }

}
