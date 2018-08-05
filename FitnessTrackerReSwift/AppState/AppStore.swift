//
//  AppStore.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

/// Our global `Store`. Do not dispatch actions directly--instead, use `dispatchToStore(_:)`.
internal let store = Store<AppState>(
    initialValue: .initial,
    reducer: appReducer,
    middlewares: []
)

/// Our global Store dispatch queue. Used for dispatching Actions to our global Store.
internal let storeDispatchQueue = DispatchQueue(label: "com.smolster.FitnessTracker.store")


/**
 Safely dispatches an `Action` to our global Store.
 
 - parameter action: The `Action` to dispatch.
 */
internal func dispatchToStore(_ action: Action) {
    storeDispatchQueue.async {
        store.dispatch(action)
    }
}
