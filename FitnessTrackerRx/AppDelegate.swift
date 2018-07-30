//
//  AppDelegate.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static fileprivate(set) weak var shared: AppDelegate!

    internal let window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = RootTabController()
        return window
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.shared = self
        
        FitnessTrackerKit.GlobalStyles.apply()
        
        window.makeKeyAndVisible()
        return true
    }

}

