//
//  MealObject.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RealmSwift

internal class MealObject: RealmSwift.Object {
    /// time interval since 1970
    @objc dynamic private var dateOfMeal: Double = 0.0
    
    @objc dynamic private var componentsAndAmounts: [ComponentAndAmount] = []
    
    @objc dynamic private var proteinGrams: Int = 0
    @objc dynamic private var fatGrams: Int = 0
    @objc dynamic private var carbGrams: Int = 0
    
    var date: Date {
        return Date(timeIntervalSince1970: dateOfMeal)
    }
    
    convenience init(meal: Meal) {
        self.init(
            date: meal.entryDate,
            proteinGrams: meal.totalMacros.protein.rawValue,
            fatGrams: meal.totalMacros.fat.rawValue,
            carbGrams: meal.totalMacros.carbs.rawValue
        )
    }
    
    internal func makeMeal() -> Meal {
        return .init(
            entryDate: self.date,
            componentsAndAmounts: self.componentsAndAmounts.map { $0.makeComponentAndAmount() }
        )
    }
}

private extension MealObject {
    class ComponentAndAmount: Object {
        @objc dynamic private var component: Object = Object()
        @objc dynamic private var amount: Int = 0
        
        fileprivate convenience init(_ componentAndAmount: Meal.ComponentAndAmount) {
            self.init()
            switch componentAndAmounts.component {
            case .recipe(let recipe):
                self.component = RecipeObject(recipe: recipe)
            case .ingredient(let ingredient):
                self.component = IngredientObject(ingredient: ingredient)
            }
            self.amount = componentAndAmount.amount.rawValue
        }
        
        fileprivate func makeComponentAndAmount() -> (component: Meal.Component, amount: Grams) {
            let component: Meal.Component
            if let recipeObj = self.component as? RecipeObject {
                component = .recipe(recipeObj.makeRecipe())
            } else {
                component = .ingredient((self.component as! IngredientObject).makeIngredient())
            }
            return (component, .init(rawValue: self.amount))
        }
    }
}

internal extension MealObject {
    
}
