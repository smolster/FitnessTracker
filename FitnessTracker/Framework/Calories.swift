//
//  Calories.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public enum CaloriesTag { }
public typealias Calories = SimpleTag<CaloriesTag, Int>

public func +(_ lhs: Calories, _ rhs: Calories) -> Calories {
    return .init(rawValue: lhs.rawValue + rhs.rawValue)
}
