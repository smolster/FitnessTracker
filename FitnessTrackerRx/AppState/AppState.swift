//
//  AppState.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import ReSwift

public protocol HasInitial {
    static var initial: Self { get }
}

internal struct AppState: StateType {
    var viewState: ViewState
}

extension AppState: HasInitial {
    internal static var initial: AppState {
        return AppState(
            viewState: .initial
        )
    }
}
