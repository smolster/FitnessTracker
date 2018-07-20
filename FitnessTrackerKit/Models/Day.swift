//
//  Day.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/19/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct Day {
    public let date: Date
    public let totalCalories: Calories
    public let totalMacros: Macros
    public let allMeals: [Meal]
}
