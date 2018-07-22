//
//  Ingredient.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct Ingredient: MacroCalculatable {
    /// Name of ingredient.
    public let name: String
    
    /// Macros in 100 grams of ingredient.
    public let macrosIn100g: MacroCount
    
    public func macros(in gramsOfItem: Grams) -> MacroCount {
        return macrosIn100g * (gramsOfItem.rawValue / 100)
    }
    
    public init(name: String, macrosIn100g: MacroCount) {
        self.name = name
        self.macrosIn100g = macrosIn100g
    }
}
