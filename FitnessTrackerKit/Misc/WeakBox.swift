//
//  WeakBox.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

/// A wrapper around a `weak` object. Use to wrap a class when you need to store a weak reference to it.
public final class WeakBox<T: AnyObject> {
    
    /// The weak reference to the contained object.
    public weak var object: T?
    
    /**
     Initializes and returns a new WeakBox containing the provided `object`.
     
     - parameter object: The object to box.
     */
    init(_ object: T) {
        self.object = object
    }
}
