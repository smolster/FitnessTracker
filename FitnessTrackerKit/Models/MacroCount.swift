//
//  MacroCount.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct MacroCount: Codable, Equatable {
    public var protein: Grams
    public var carbs: Grams
    public var fat: Grams
    
    /// The calorie-count of this macro count
    public var calories: Calories {
        return .init(rawValue: (protein.rawValue * 4) + (carbs.rawValue * 4) + (fat.rawValue * 9))
    }
    
    public init(protein: Grams, carbs: Grams, fat: Grams) {
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
    
    static var zero: MacroCount {
        return .init(protein: 0, carbs: 0, fat: 0)
    }
}

extension MacroCount: CustomStringConvertible {
    public var description: String {
        return "Protein: \(self.protein.rawValue)g | Carbs: \(self.carbs.rawValue)g | Fat: \(self.fat.rawValue)g"
    }
}

public func *(_ lhs: MacroCount, _ rhs: Int) -> MacroCount {
    return .init(
        protein: .init(rawValue: lhs.protein.rawValue * rhs),
        carbs: .init(rawValue: lhs.carbs.rawValue * rhs),
        fat: .init(rawValue: lhs.fat.rawValue * rhs)
    )
}

public func +(_ lhs: MacroCount, _ rhs: MacroCount) -> MacroCount {
    return .init(
        protein: lhs.protein + rhs.protein,
        carbs: lhs.carbs + rhs.carbs,
        fat: lhs.fat + rhs.fat
    )
}
