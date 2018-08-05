//
//  Day.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/19/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct Day: Equatable, Codable {
    
    internal struct DisplayDate: Equatable, Codable {
        let dateString: String
        let timeZone: TimeZone
    }
    
    public let date: Date
    public let totalCalories: Calories
    public let totalMacros: MacroCount
    public let allMeals: [Meal]
    internal let displayDateStruct: DisplayDate
    
    public var displayDate: (dateString: String, timeZone: TimeZone) {
        return (self.displayDate.dateString, self.displayDateStruct.timeZone)
    }
    
    init(date: Date, totalCalories: Calories, totalMacros: MacroCount, allMeals: [Meal], displayDate: (String, TimeZone)) {
        self.date = date
        self.totalCalories = totalCalories
        self.totalMacros = totalMacros
        self.allMeals = allMeals
        self.displayDateStruct = .init(dateString: displayDate.0, timeZone: displayDate.1)
    }
    
    public var isToday: Bool {
        let calendar = Calendar.current
        let selfDateComponents = calendar.dateComponents([.day, .month, .year], from: self.date)
        let todayComponents = calendar.dateComponents([.day, .month, .year], from: .init())
        return selfDateComponents == todayComponents
    }
}
