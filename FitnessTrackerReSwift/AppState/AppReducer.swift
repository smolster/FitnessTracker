//
//  AppReducer.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

internal func appReducer(action: Action, _ oldState: AppState) -> AppState {
    var newState = oldState

    if let resourceAction = action as? ResourceAction<AppState> {
        resourceAction.apply(to: &newState)
    } else if let navigationAction = action as? NavigationAction {
        newState.viewState = navigationReducer(oldState.viewState, action: navigationAction)
    } else {
        fatalError("Unsupported action sent to app reducer: \(action)")
    }
    return newState
}
