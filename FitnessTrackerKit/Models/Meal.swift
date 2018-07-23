//
//  Meal.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct Meal {
    
    public typealias ComponentAndAmount = (component: Component, amount: Grams)
    
    public enum Component: MacroCalculatable {
        
        public enum Kind {
            case ingredient, recipe
        }
        
        case recipe(Recipe)
        case ingredient(Ingredient)
        
        public func macros(in gramsOfItem: Grams) -> MacroCount {
            switch self {
            case .recipe(let recipe): return recipe.macros(in: gramsOfItem)
            case .ingredient(let ingredient): return ingredient.macros(in: gramsOfItem)
            }
        }
        
        public var name: String {
            switch self {
            case .recipe(let recipe): return recipe.name
            case .ingredient(let ingredient): return ingredient.name
            }
        }
        
        public var kind: Kind {
            switch self {
            case .recipe: return .recipe
            case .ingredient: return .ingredient
            }
        }
    }
    
    public let entryDate: Date
    public let componentsAndAmounts: [ComponentAndAmount]
    
    public let totalMacros: MacroCount
    
    public var calories: Calories {
        return totalMacros.calories
    }
    
    public init(entryDate: Date, componentsAndAmounts: [ComponentAndAmount]) {
        self.entryDate = entryDate
        self.componentsAndAmounts = componentsAndAmounts
        self.totalMacros = componentsAndAmounts.reduce(.zero) { result, item in
            return result + item.component.macros(in: item.amount)
        }
    }
}
