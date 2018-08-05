//
//  Meal.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public struct Meal: Identifiable, Equatable, Codable {
    
    public struct ComponentAndAmount: Equatable, Codable {
        let component: Component
        let amount: Grams
    }
    
    public let id: Id
    
    public let entryDate: Date
    public let componentsAndAmounts: [ComponentAndAmount]
    
    public let totalMacros: MacroCount
    
    public var calories: Calories {
        return totalMacros.calories
    }
    
    internal init(id: Id, entryDate: Date, componentsAndAmounts: [ComponentAndAmount]) {
        self.id = id
        self.entryDate = entryDate
        self.componentsAndAmounts = componentsAndAmounts
        self.totalMacros = componentsAndAmounts.reduce(.zero) { result, item in
            return result + item.component.macros(in: item.amount)
        }
    }
}

public extension Meal {
    public enum Component: MacroCalculatable, Equatable, Codable {
        
        public enum Kind {
            case ingredient, recipe
        }
        
        case recipe(Recipe)
        case ingredient(Ingredient)
        
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let recipe = try? container.decode(Recipe.self) {
                self = .recipe(recipe)
            } else {
                self = .ingredient(try container.decode(Ingredient.self))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .recipe(let recipe):
                try container.encode(recipe)
            case .ingredient(let ingredient):
                try container.encode(ingredient)
            }
        }
        
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
}
