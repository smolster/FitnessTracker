//
//  ViewState.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit

internal typealias CoreState = Equatable & Codable

internal struct ViewState: CoreState, HasInitial {
    internal var tabStacks: TabStacks
    internal var modal: ModalNavigationStack?
    internal var selectedTab: Tab
    
    internal static var initial: ViewState {
        return ViewState(
            tabStacks: .initial,
            modal: nil,
            selectedTab: .today
        )
    }
}

extension ViewState {
    internal enum Tab: Int, CoreState {
        
        case today
        case allMeals
        case settings
        
        internal var index: Int {
            return self.rawValue
        }
        
        internal static var allCases: [Tab] {
            return [.today, .allMeals, .settings]
        }
        
        internal var name: String {
            switch self {
            case .allMeals:     return "All Meals"
            case .today:        return "Today"
            case .settings:     return "Settings"
            }
        }
        
        internal var rootViewControllerType: UIViewController.Type {
            switch self {
            case .allMeals:
                return AllMealsViewController.self
            case .today:
                return TodayViewController.self
            case .settings:
                // TODO
                return UIViewController.self
            }
        }
        
        internal func createRootViewController() -> UINavigationController {
            return UINavigationController(rootViewController: self.rootViewControllerType.init())
        }
        
        internal func tabBarItem() -> UITabBarItem {
            let item: UITabBarItem
            switch self {
            case .allMeals:
                item = .init(title: self.name, image: nil, selectedImage: nil)
            case .today:
                item = .init(title: self.name, image: nil, selectedImage: nil)
            case .settings:
                item = .init(title: self.name, image: nil, selectedImage: nil)
            }
            item.tag = self.rawValue
            return item
        }
    }
}

extension ViewState {
    /// Simple wrapper around a dictionary that allows us to avoid dealing with optionals
    internal struct TabStacks: HasInitial, CoreState {
        private var dict: [Tab: [ViewController]]
        
        internal subscript(_ tab: Tab) -> [ViewController] {
            get {
                return dict[tab] ?? []
            }
            set {
                self.dict[tab] = newValue
            }
        }
        
        internal static var initial: ViewState.TabStacks {
            return self.init(dict: [
                .today: [.today],
                .allMeals: [.allMeals],
                .settings: [.settings]
            ])
        }
    }
}
