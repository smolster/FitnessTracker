//
//  Resource.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

/// Represents the state of a loadable asynchronous resource.
public enum Resource<T> {
    
    /// This `Resource` hasn't been queried yet.
    case notQueried
    
    /// This `Resource` is currently loading.
    case loading
    
    /// This `Resource` has been loaded.
    case loaded(T)
    
    /// This `Resource` failed to load.
    case loadFailed(Error)
}
