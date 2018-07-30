//
//  Array+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

extension Array {
    /**
     Pops the last element off of `self` until the last element satisfies the `predicate`.
     
     - parameter predicate: The predicate to use.
     
     - returns: The popped elements. The first element popped is at the beginning of the array, and the last element popped is at the end.
     */
    @discardableResult
    public mutating func removeLast(until predicate: (Element) throws -> Bool) rethrows -> [Element] {
        var popped = [Element]()
        while let last = self.last, try predicate(last) == false {
            popped.append(self.removeLast())
        }
        return popped
    }
}
