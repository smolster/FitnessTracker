//
//  Meal.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct Meal {
    public let entryDate: Date
    public let macros: Macros
    
    public var calories: Calories {
        return .init(rawValue: (macros.protein.rawValue * 4) + (macros.carbs.rawValue * 4) + (macros.fat.rawValue * 9))
    }
    
    public init(entryDate: Date, macros: Macros) {
        self.entryDate = entryDate
        self.macros = macros
    }
}
