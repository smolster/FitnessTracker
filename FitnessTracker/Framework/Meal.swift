//
//  Meal.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public enum Macro: String, Codable, Equatable {
    case carbs
    case protein
    case fat
    
    /**
     Returns the number of calories in a given number of `grams` of this macro.
     
     - parameter grams: The number of grams of the macro.
     */
    public func calories(in grams: Grams) -> Calories {
        switch self {
        case .carbs, .protein:
            return .init(rawValue: grams.rawValue * 4)
        case .fat:
            return .init(rawValue: grams.rawValue * 9)
        }
    }
}

public struct Meal {
    public let entryDate: Date
    public let macroCount: [Macro: Grams]
    
    public var calories: Calories {
        return macroCount.reduce(0) { current, next in
            return current + next.key.calories(in: next.value)
        }
    }
    
    public init(entryDate: Date, macroCount: [Macro: Grams]) {
        self.entryDate = entryDate
        self.macroCount = macroCount
    }
}
