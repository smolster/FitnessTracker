//
//  APIService.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit

internal class NetworkProvider {
    
    private var service: APIServiceType
    
    init(service: APIServiceType) {
        self.service = service
    }
    
    private func loadAndUpdate<Model>(keyPath: WritableKeyPath<AppState, Resource<Model>>, fetch: (_ completion: @escaping (Model) -> Void) -> Void) {
        dispatchToStore(ResourceAction(.beganLoading, keyPath: keyPath))
        fetch { model in
            dispatchToStore(ResourceAction(.didLoad(model), keyPath: keyPath))
        }
    }
    
    internal func loadMeals() {
        loadAndUpdate(keyPath: \AppState.allMeals, fetch: service.getAllMealEntries(completion:))
    }
    
    internal func loadIngredients() {
        loadAndUpdate(keyPath: \AppState.allIngredients, fetch: service.getAllIngredients(completion:))
    }
    
    internal func loadRecipes() {
        loadAndUpdate(keyPath: \AppState.allRecipes, fetch: service.getAllRecipes(completion:))
    }
    
    internal func loadMealsByDay() {
        loadAndUpdate(keyPath: \AppState.allMealsByDay) { completion in
            service.getAllMealsByDay(in: .current, completion: completion)
        }
    }
    
    internal func addMeal(entryDate: Date, componentsAndAmounts: [Meal.ComponentAndAmount]) {
        // TODO: Edit state in some fashion to display spinner or something.
        service.addMeal(entryDate: entryDate, componentsAndAmounts: componentsAndAmounts) { [unowned self] _ in
            self.loadIngredients()
        }
    }
    
    internal func addRecipe(name: String, ingredientsAndAmounts: [Recipe.IngredientAndAmount]) {
        // TODO: Edit state in some fashion to display spinner or something.
        service.addRecipe(name: name, ingredientsAndAmounts: ingredientsAndAmounts) { [unowned self] _ in
            self.loadRecipes()
        }
    }
    
    internal func addIngredient(name: String, macrosIn100g: MacroCount) {
        // TODO: Edit state in some fashion to display spinner or something.
        service.addIngredient(name: name, macrosIn100g: macrosIn100g) { [unowned self] _ in
            self.loadIngredients()
        }
    }
}
