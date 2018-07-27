//
//  APIServiceType.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RxSwift

public protocol APIServiceType: class {
    
    func addIngredient(name: String, macrosIn100g: MacroCount, completion: @escaping (Ingredient) -> Void)
    
    func getAllIngredients(completion: @escaping ([Ingredient]) -> Void)
    
    func addMeal(entryDate: Date, componentsAndAmounts: [Meal.ComponentAndAmount], completion: @escaping (Meal) -> Void)
    
    func getAllMealsByDay(in timeZone: TimeZone, completion: @escaping ([Day]) -> Void)
    
    func getAllMealEntries(completion: @escaping ([Meal]) -> Void)
    
    func addRecipe(name: String, ingredientsAndAmounts: [Recipe.IngredientAndAmount], completion: @escaping (Recipe) -> Void)
    
    func getAllRecipes(completion: @escaping ([Recipe]) -> Void)
}
