//
//  Recipe.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation

public protocol Identifiable {
    associatedtype Id: Equatable
}

extension Identifiable {
    public typealias Id = SimpleTag<Self, String>
}

public struct Recipe: MacroCalculatable, Identifiable {
    public typealias IngredientAndAmount = (ingredient: Ingredient, amount: Grams)
    
    public let id: Id
    
    public let name: String
    
    public let ingredientsAndAmountsIn100g: [IngredientAndAmount]
    
    public let macrosIn100g: MacroCount
    
    public func macros(in gramsOfItem: Grams) -> MacroCount {
        return macrosIn100g * (gramsOfItem.rawValue / 100)
    }
    
    internal init(id: Id, name: String, ingredientsAndAmountsIn100g: [IngredientAndAmount]) {
        self.id = id
        self.name = name
        self.ingredientsAndAmountsIn100g = ingredientsAndAmountsIn100g
        self.macrosIn100g = ingredientsAndAmountsIn100g.reduce(.zero) { (result, item) in
            return result + item.ingredient.macros(in: item.amount)
        }
    }
}
