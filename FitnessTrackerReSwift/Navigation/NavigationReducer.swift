//
//  NavigationReducer.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

internal func navigationReducer(_ oldState: ViewState, action: NavigationAction) -> ViewState {
    var newState = oldState
    
    switch action {
    case .switchTab(let to):
        newState.selectedTab = to
    case .push(let vc):
        newState.tabStacks[newState.selectedTab].append(vc)
    case .pop:
        newState.tabStacks[newState.selectedTab].removeLast()
    case .popTo(let vc):
        newState.tabStacks[newState.selectedTab].removeLast(until: { $0 == vc })
    case .present(let vc):
        newState.modal = .single(vc)
    case .presentInNav(let vc):
        newState.modal = .stack([vc])
    case .dismissModal:
        newState.modal = nil
    case .setRoute(let route):
        newState = routeReducer(oldState, route: route)
    }
    
    return newState
}
