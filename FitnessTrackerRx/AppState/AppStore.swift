//
//  AppStore.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import ReSwift

internal let store = Store<AppState>(
    reducer: appReducer,
    state: .initial,
    middleware: []
)

internal let storeDispatchQueue = DispatchQueue(label: "com.smolster.FitnessTracker.store")

internal func dispatchToStore(_ action: Action) {
    storeDispatchQueue.async {
        store.dispatch(action)
    }
}
