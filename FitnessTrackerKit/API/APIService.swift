//
//  APIService.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

/**
 Dispatches the `action` on global `DispatchQueue`, using the default configuration.
 
 - parameter action: The action to dispatch.
 */
private func randomBackgroundDispatch(_ action: @escaping () -> Void) {
    DispatchQueue.global().async(execute: action)
}

public final class APIService: APIServiceType {
    
    public init() { }
    
    public func addIngredient(name: String, macrosIn100g: MacroCount, completion: @escaping (Ingredient) -> Void) {
        dispatchToRealm { realm in
            do {
                try realm.write {
                    let ingredient = IngredientObject.create(in: realm, name: name, macros: macrosIn100g).makeIngredient()
                    randomBackgroundDispatch {
                        completion(ingredient)
                    }
                }
            } catch {
                
            }
        }
    }
    
    public func getAllIngredients(completion: @escaping ([Ingredient]) -> Void) {
        dispatchToRealm { realm in
            let ingredients: [Ingredient] = realm.objects(IngredientObject.self).map { $0.makeIngredient() }
            randomBackgroundDispatch {
                completion(ingredients)
            }
        }
    }
    
    public func addMeal(entryDate: Date, componentsAndAmounts: [Meal.ComponentAndAmount], completion: @escaping (Meal) -> Void) {
        dispatchToRealm { realm in
            do {
                try realm.write {
                    let meal = MealObject.create(in: realm, entryDate: entryDate, componentsAndAmounts: componentsAndAmounts).makeMeal()
                    randomBackgroundDispatch {
                        completion(meal)
                    }
                }
            } catch {
                
            }
        }
    }
    
    public func getAllMealsByDay(in timeZone: TimeZone, completion: @escaping ([Day]) -> Void) {
        dispatchToRealm { realm in
            let days: [Day] = APIOptimizationFunctions.days(from: realm.objects(MealObject.self), using: timeZone)
            randomBackgroundDispatch {
                completion(days)
            }
        }
    }
    
    public func getAllMealEntries(completion: @escaping ([Meal]) -> Void) {
        dispatchToRealm { realm in
            let meals: [Meal] = realm.objects(MealObject.self).map { $0.makeMeal() }
            randomBackgroundDispatch {
                completion(meals)
            }
        }
    }
    
    public func addRecipe(name: String, ingredientsAndAmounts: [Recipe.IngredientAndAmount], completion: @escaping (Recipe) -> Void) {
        dispatchToRealm { realm in
            do {
                try realm.write {
                    let recipe = RecipeObject.create(in: realm, name: name, ingredientsAndAmountsIn100g: ingredientsAndAmounts).makeRecipe()
                    randomBackgroundDispatch {
                        completion(recipe)
                    }
                }
            } catch {
                
            }
        }
    }
    
    public func getAllRecipes(completion: @escaping ([Recipe]) -> Void) {
        dispatchToRealm { realm in
            let recipes: [Recipe] = realm.objects(RecipeObject.self).map { $0.makeRecipe() }
            randomBackgroundDispatch {
                completion(recipes)
            }
        }
    }
    
}
