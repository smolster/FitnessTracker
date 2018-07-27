//
//  APIOptimizationFunctions.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

/**
 This struct is used for name-spacing complex functions used for optimizing processing of database results.
 */
internal struct APIOptimizationFunctions {
    internal static func days<MealObjects: Sequence>(from mealObjects: MealObjects, using timeZone: TimeZone) -> [Day] where MealObjects.Element == MealObject {
        return mealObjects
            .reduce(into: [String: (date: Date, meals: [Meal])]()) { currentDict, mealObj in
                let dateString = DateCacher.shared.string(from: mealObj.date, using: .mDDYYYY(timeZone))
                if currentDict[dateString] == nil {
                    currentDict[dateString] = (mealObj.date, [mealObj.makeMeal()])
                } else {
                    currentDict[dateString]!.meals.append(mealObj.makeMeal())
                }
                currentDict[dateString]!.meals.sort(by: { $0.entryDate < $1.entryDate })
            }
            .map { pair in
                let (totalCals, totalMacros): (calories: Calories, macros: MacroCount) =
                    pair.value.meals.reduce((.zero, .zero)) { currentCalsAndMacros, meal in
                        return (currentCalsAndMacros.calories + meal.calories, currentCalsAndMacros.macros + meal.totalMacros)
                }
                return Day(date: pair.value.date, totalCalories: totalCals, totalMacros: totalMacros, allMeals: pair.value.meals, displayDate: (pair.key, timeZone))
        }
    }
}
