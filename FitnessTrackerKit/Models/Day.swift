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
    public let totalMacros: MacroCount
    public let allMeals: [Meal]
    public let displayDate: (dateString: String, timeZone: TimeZone)
    
    init(date: Date, totalCalories: Calories, totalMacros: MacroCount, allMeals: [Meal], displayDate: (String, TimeZone)) {
        self.date = date
        self.totalCalories = totalCalories
        self.totalMacros = totalMacros
        self.allMeals = allMeals
        self.displayDate = displayDate
    }
}
