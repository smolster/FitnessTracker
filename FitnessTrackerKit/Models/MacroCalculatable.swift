//
//  MacroCalculatable.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public protocol MacroCalculatable {
    /**
     Returns the `MacroCount` in a given amount of the item.
     
     - parameter gramsOfItem: The amount of the item.
     */
    func macros(in gramsOfItem: Grams) -> MacroCount
}

public extension MacroCalculatable {
    /**
     Returns the total calorie count in a given amount of the item.
     
     - parameter gramsOfItem: The amount of the item.
     */
    public func calories(in gramsOfItem: Grams) -> Calories {
        return self.macros(in: gramsOfItem).calories
    }
}
