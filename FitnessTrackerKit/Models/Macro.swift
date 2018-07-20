//
//  Macro.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation


public enum MacroType: String, Codable, Equatable {
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
