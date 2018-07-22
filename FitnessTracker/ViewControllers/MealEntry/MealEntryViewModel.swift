//
//  MealEntryViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import FitnessTrackerKit
import ReactiveSwift
import Result

internal protocol MealEntryViewModelInputs {
    /// Call when the submit button is pressed
    func donePressed()
    
    func recipeChosen(_ recipe: Recipe)
    func recipeAmountProvided(_ recipe: Recipe, amount: Grams)
    
    func addIngredientPressed()
    func ingredientChosen(_ newIngredient: Ingredient)
    func ingredientAmountProvided(for ingredient: Ingredient, amount: Grams)
    
}

internal protocol MealEntryViewModelOutputs {
    
    var showAlertToGatherAmountForComponent: Signal<Meal.Component, NoError> { get }
    var insertIngredient: Signal<(Ingredient, Grams), NoError> { get }
    var goToIngredientSelection: Signal<Void, NoError> { get }
    
    var showConfirmationAndClearFields: Signal<Void, NoError> { get }
}

internal protocol MealEntryViewModelType {
    var inputs: MealEntryViewModelInputs { get }
    var outputs: MealEntryViewModelOutputs { get }
}

final class MealEntryViewModel: MealEntryViewModelInputs, MealEntryViewModelOutputs, MealEntryViewModelType {
    
    init(service: APIService = APIService()) {
        self.goToIngredientSelection = addIngredientPressedProperty.signal
        
        self.showAlertToGatherAmountForComponent = Signal<Meal.Component, NoError>
            .merge(
                ingredientChosenProperty.signal.skipNil().map { .ingredient($0) },
                recipeChosenProperty.signal.skipNil().map { .recipe($0) }
            )
        
        self.insertIngredient = ingredientAmountProvidedProperty
            .signal
            .skipNil()
        
        let currentComponentsAndAmounts = Signal<Meal.ComponentAndAmount, NoError>
            .merge(
                ingredientAmountProvidedProperty.signal.skipNil().map { (.ingredient($0.0), $0.1) },
                recipeAmountProvidedProperty.signal.skipNil().map { (.recipe($0.0), $0.1) }
            )
            .collect()
        
        self.showConfirmationAndClearFields = donePressedProperty
            .signal
            .withJustLatest(from: currentComponentsAndAmounts)
            .map { Meal(entryDate: .init(), componentsAndAmounts: $0) }
            .flatMap(.latest, service.add(mealEntry:))
    }
    
    // MARK: - Inputs
    
    private let donePressedProperty = MutableProperty<Void>(())
    internal func donePressed() {
        self.donePressedProperty.value = ()
    }
    
    private let recipeChosenProperty = MutableProperty<Recipe?>(nil)
    internal func recipeChosen(_ recipe: Recipe) {
        self.recipeChosenProperty.value = recipe
    }
    
    private let recipeAmountProvidedProperty = MutableProperty<(Recipe, Grams)?>(nil)
    internal func recipeAmountProvided(_ recipe: Recipe, amount: Grams) {
        self.recipeAmountProvidedProperty.value = (recipe, amount)
    }
    
    private let ingredientChosenProperty = MutableProperty<Ingredient?>(nil)
    func ingredientChosen(_ newIngredient: Ingredient) {
        self.ingredientChosenProperty.value = newIngredient
    }
    
    private let ingredientAmountProvidedProperty = MutableProperty<(Ingredient, Grams)?>(nil)
    func ingredientAmountProvided(for ingredient: Ingredient, amount: Grams) {
        self.ingredientAmountProvidedProperty.value = (ingredient, amount)
    }
    
    private let addIngredientPressedProperty = MutableProperty<Void>(())
    func addIngredientPressed() {
        self.addIngredientPressedProperty.value = ()
    }
    
    
    // MARK: - Outputs
    
    let goToIngredientSelection: Signal<Void, NoError>
    let insertIngredient: Signal<(Ingredient, Grams), NoError>
    let showAlertToGatherAmountForComponent: Signal<Meal.Component, NoError>
    
    let showConfirmationAndClearFields: Signal<Void, NoError>
    
    var inputs: MealEntryViewModelInputs { return self }
    var outputs: MealEntryViewModelOutputs { return self }
}
