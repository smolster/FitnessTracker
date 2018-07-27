//
//  ViewState.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import UIKit

typealias CoreState = Equatable & Codable

internal struct ViewState: CoreState {
    static var initial: ViewState {
        return ViewState(
            tabStacks: .initial,
            modal: nil,
            selectedTab: .mealEntry
        )
    }
    
    enum Tab: Int, CoreState {
        
        case mealEntry
        case allMeals
        case today
        case settings
        
        internal var index: Int {
            return self.rawValue
        }
        
        internal static var allCases: [Tab] {
            return [.mealEntry, .allMeals, .today, .settings]
        }
        
        internal var name: String {
            switch self {
            case .mealEntry:    return "Meal Entry"
            case .allMeals:     return "All Meals"
            case .today:        return "Today"
            case .settings:     return "Settings"
            }
        }
        
        var rootViewControllerType: UIViewController.Type {
            switch self {
            case .mealEntry:
                return MealEntryViewController.self
            case .allMeals:
                return AllMealsViewController.self
            case .today:
                return UIViewController.self
            case .settings:
                return UIViewController.self
            }
        }
        
        internal func createRootViewController() -> UINavigationController {
            return UINavigationController(rootViewController: self.rootViewControllerType.init())
        }
        
        internal func tabBarItem() -> UITabBarItem {
            let item: UITabBarItem
            switch self {
            case .mealEntry:
                item = .init(title: self.name, image: nil, selectedImage: nil)
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
    
    var tabStacks: TabStacks
    var modal: ModalNavigationStack?
    var selectedTab: Tab
    
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
        
        static var initial: ViewState.TabStacks {
            
            return self.init(dict: [
                .mealEntry: [.mealEntryRoot],
                .allMeals: [.allMealsRoot],
                .today: [.todayRoot],
                .settings: [.settingsRoot]
            ])
        }
    }
}


