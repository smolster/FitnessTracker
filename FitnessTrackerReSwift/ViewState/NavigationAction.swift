//
//  NavigationAction.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import ReSwift

internal enum Route { }

typealias CoreAction = Action

internal enum NavigationAction: CoreAction {
    
    /// Switches to a provided tab.
    case switchTab(to: ViewState.Tab)
    
    /// Pushes a view controller onto the currently selected tab stack.
    case pushViewController(ViewController)
    
    /// Pops the top view controller from the currently selected tab's stack.
    case popViewController
    
    /// Pops to a view controller within the currently selected tab's stack. If the view controller is not present, no action will be taken.
    case popToViewController(ViewController)
    
    /// Presents a view controller on the top-most view controller of the currently selected tab's stack.
    case presentViewController(ViewController)
    
    /// Presents a view controller wrapped in a navigation controller on the top-most view controller of the currently selected tab's stack.
    case presentInNav(ViewController)
    
    /// Dismisses the currently displayed modal view controller.
    case dismissModal
    
    /// Sets the view hierarchy to the route, and navigates the user there, if necessary.
    case setRoute(Route)
    
    var loggingString: String {
        switch self {
        case .switchTab(to: let toTab):
            return "Switched to \(toTab.name) tab."
        case .pushViewController(let viewController):
            return "Pushed view controller of type \(viewController)."
        case .popViewController:
            return "Popped view controller."
        case .popToViewController(let viewController):
            return "Popped to view controller: \(viewController.rawValue)"
        case .presentViewController(let viewController):
            return "Presented view controller: \(viewController.rawValue)"
        case .presentInNav(let viewController):
            return "Presented view controller in nav: \(viewController.rawValue)"
        case .dismissModal:
            return "Dismissed modal"
        case .setRoute:
            return "Route set."
        }
    }
}
