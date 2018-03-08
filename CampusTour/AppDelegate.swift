//
//  AppDelegate.swift
//  CampusTour
//
//  Created by Serge-Olivier Amega on 2/28/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import UIKit
import Keys
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared : AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var window: UIWindow?
    let locationProvider = LocationProvider()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Google maps
        let keys = CampusTourKeys()
        GMSServices.provideAPIKey(keys.googleMapsAPI)
        
        //set up gui
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = MainTabBarController(())
        window?.makeKeyAndVisible()
        
        return true
    }
}
