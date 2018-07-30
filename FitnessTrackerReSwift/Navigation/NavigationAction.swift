//
//  NavigationAction.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import ReSwift

internal enum NavigationAction: CoreAction {
    
    /// Switches to a provided tab.
    case switchTab(to: ViewState.Tab)
    
    /// Pushes a view controller onto the currently selected tab stack.
    case push(ViewController)
    
    /// Pops the top view controller from the currently selected tab's stack.
    case pop
    
    /// Pops to a view controller within the currently selected tab's stack. If the view controller is not present, no action will be taken.
    case popTo(ViewController)
    
    /// Presents a view controller on the top-most view controller of the currently selected tab's stack.
    case present(ViewController)
    
    /// Presents a view controller wrapped in a navigation controller on the top-most view controller of the currently selected tab's stack.
    case presentInNav(ViewController)
    
    /// Dismisses the currently displayed modal view controller.
    case dismissModal
    
    /// Sets the view hierarchy to the route, and navigates the user there, if necessary.
    case setRoute(Route)
}
