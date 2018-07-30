//
//  RootTabController.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

internal final class RootTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
}

extension RootTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        var selectedViewControllerType = type(of: viewController)
        if let navVC = viewController as? UINavigationController {
            selectedViewControllerType = type(of: navVC.viewControllers.first!)
        }
        
        let selectedTab = ViewState.Tab.allCases.first(where: { $0.rootViewControllerType == selectedViewControllerType })!
        
        dispatchToStore(NavigationAction.switchTab(to: selectedTab))
        // Return false--state subscribers will handle ACTUALLY selecting the tab
        return false
    }
}

