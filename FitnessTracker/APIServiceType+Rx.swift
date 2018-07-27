//
//  APIServiceType+Rx.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/26/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RxSwift
import FitnessTrackerKit

extension APIServiceType {
    
    internal func rxAddRecipe(name: String, ingredientsAndAmounts: [Recipe.IngredientAndAmount]) -> Observable<Recipe> {
        return .create { observer in
            self.addRecipe(name: name, ingredientsAndAmounts: ingredientsAndAmounts, completion: observer.onNextAndComplete(with:))
            return Disposables.create()
        }
    }
    
    internal func rxAddMeal(entryDate: Date, componentsAndAmounts: [Meal.ComponentAndAmount]) -> Observable<Meal> {
        return .create { observer in
            self.addMeal(entryDate: entryDate, componentsAndAmounts: componentsAndAmounts, completion: observer.onNextAndComplete(with:))
            return Disposables.create()
        }
    }
    
    internal func rxAddIngredient(name: String, macrosIn100g: MacroCount) -> Observable<Ingredient> {
        return .create { observer in
            self.addIngredient(name: name, macrosIn100g: macrosIn100g, completion: observer.onNextAndComplete(with:))
            return Disposables.create()
        }
    }
    
    internal func rxAllMealsByDay(in timeZone: TimeZone) -> Observable<[Day]> {
        return .create { observer in
            self.getAllMealsByDay(in: timeZone, completion: observer.onNextAndComplete(with:))
            return Disposables.create()
        }
    }
    
    internal func rxAllIngredients() -> Observable<[Ingredient]> {
        return .create { observer in
            self.getAllIngredients(completion: observer.onNextAndComplete(with:))
            return Disposables.create()
        }
    }
    
    internal func rxAllRecipes() -> Observable<[Recipe]> {
        return .create { observer in
            self.getAllRecipes(completion: observer.onNextAndComplete(with:))
            return Disposables.create()
        }
    }
    
    internal func rxGetAllMealsByDay(in timeZone: TimeZone) -> Observable<[Day]> {
        return .create { observer in
            self.getAllMealsByDay(in: timeZone, completion: observer.onNextAndComplete(with:))
            return Disposables.create()
        }
    }
}
