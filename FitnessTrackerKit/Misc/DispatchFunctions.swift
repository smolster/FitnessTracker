//
//  DispatchFunctions.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public func dispatchToMainIfNeeded(block: @escaping () -> Void) {
    if Thread.current.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

public func dispatchToMainIfNeededSync(block: () -> Void) {
    if Thread.current.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync(execute: block)
    }
}
