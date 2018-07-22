//
//  RecipeObject.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RealmSwift

final internal class RecipeObject: MealObjectComponent {
    @objc private dynamic var name: String = ""
    private let ingredientsAndAmounts = List<RecipeObjectIngredientAndAmount>()
    
    internal convenience init(recipe: Recipe) {
        self.init()
        self.name = recipe.name
        recipe.ingredientsAndAmountsIn100g.forEach { ingredientAndAmount in
            self.ingredientsAndAmounts.append(RecipeObjectIngredientAndAmount(ingredient: ingredientAndAmount.ingredient, amount: ingredientAndAmount.amount))
        }
    }
    
    internal func makeRecipe() -> Recipe {
        return .init(
            name: self.name,
            ingredientsAndAmountsIn100g: self.ingredientsAndAmounts.map { $0.makeIngredientAndAmount() }
        )
    }
}

// This class is used to optimize, so we dont have to map over N twice (once for ingredients, once for amounts)
internal class RecipeObjectIngredientAndAmount: RealmSwift.Object {
    @objc private dynamic var ingredient: IngredientObject? = nil
    @objc private dynamic var amount: Int = 0
    
    convenience init(ingredient: Ingredient, amount: Grams) {
        self.init()
        self.ingredient = IngredientObject(ingredient: ingredient)
        self.amount = amount.rawValue
    }
    
    fileprivate func makeIngredientAndAmount() -> (ingredient: Ingredient, amount: Grams) {
        return (self.ingredient!.makeIngredient(), .init(rawValue: self.amount))
    }
}

