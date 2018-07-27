//
//  AppState.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import ReSwift
import FitnessTrackerKit

internal struct AppState: StateType {
    var viewState: ViewState
    
    var allMeals: Resource<[Meal]>
}

extension AppState: HasInitial {
    internal static var initial: AppState {
        return AppState(
            viewState: .initial,
            allMeals: .notQueried
        )
    }
}
