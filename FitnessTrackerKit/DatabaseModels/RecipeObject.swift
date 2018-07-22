//
//  RecipeObject.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RealmSwift

final internal class RecipeObject: Object {
    @objc private dynamic var name: String = ""
    @objc private dynamic var ingredientsAndAmounts: [IngredientAndAmount] = []
    
    internal convenience init(recipe: Recipe) {
        self.init()
        self.name = recipe.name
        self.ingredientsAndAmounts = recipe.ingredientsAndAmountsIn100g.map(IngredientAndAmount.init)
    }
    
    internal func makeRecipe() -> Recipe {
        return .init(
            name: self.name,
            ingredientsAndAmountsIn100g: self.ingredientsAndAmounts.map { $0.makeIngredientAndAmount() }
        )
    }
}

private extension RecipeObject {
    // This class is used to optimize, so we dont have to map over N twice (once for ingredients, once for amounts)
    class IngredientAndAmount: Object {
        @objc private dynamic var ingredient: IngredientObject = IngredientObject()
        @objc private dynamic var amount: Int = 0
        
        convenience init(ingredient: Ingredient, amount: Grams) {
            self.init()
            self.ingredient = IngredientObject(ingredient: ingredient)
            self.amount = amount.rawValue
        }
        
        fileprivate func makeIngredientAndAmount() -> (ingredient: Ingredient, amount: Grams) {
            return (self.ingredient.makeIngredient(), .init(rawValue: self.amount))
        }
    }
}

