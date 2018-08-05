//
//  RecipeObject.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RealmSwift

final internal class RecipeObject: RealmSwift.Object {
    
    @objc private dynamic var id: String = UUID().uuidString
    
    @objc private dynamic var name: String = ""
    private let ingredientsAndAmounts = List<RecipeObjectIngredientAndAmount>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    internal static func create(in realm: Realm, name: String, ingredientsAndAmountsIn100g: [Recipe.IngredientAndAmount]) -> RecipeObject {
        let object = realm.create(RecipeObject.self)
        object.name = name
        
        ingredientsAndAmountsIn100g.forEach { ingredientAndAmount in
            object.ingredientsAndAmounts.append(
                RecipeObjectIngredientAndAmount.create(
                    in: realm,
                    ingredientId: ingredientAndAmount.ingredient.id,
                    amount: ingredientAndAmount.amount
                )
            )
        }
        return object
    }
    
    internal func makeRecipe() -> Recipe {
        return .init(
            id: .init(rawValue: self.id),
            name: self.name,
            ingredientsAndAmountsIn100g: self.ingredientsAndAmounts.map { $0.makeIngredientAndAmount() }
        )
    }
}

// This class is used to optimize, so we dont have to map over N twice (once for ingredients, once for amounts)
internal class RecipeObjectIngredientAndAmount: RealmSwift.Object {
    @objc private dynamic var ingredient: IngredientObject? = nil
    @objc private dynamic var amount: Int = 0
    
    fileprivate static func create(in realm: Realm, ingredientId: Ingredient.Id, amount: Grams) -> RecipeObjectIngredientAndAmount {
        let object = realm.create(RecipeObjectIngredientAndAmount.self)
        object.ingredient = realm.object(ofType: IngredientObject.self, forPrimaryKey: ingredientId.rawValue)
        object.amount = amount.rawValue
        return object
    }
    
    fileprivate func makeIngredientAndAmount() -> Recipe.IngredientAndAmount {
        return .init(ingredient: self.ingredient!.makeIngredient(), amount: .init(rawValue: self.amount))
    }
}

