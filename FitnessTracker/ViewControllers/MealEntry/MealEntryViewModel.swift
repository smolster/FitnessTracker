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
    
    /// Call when "Recipe" button is pressed.
    func addRecipePressed()
    
    /// Call when "Ingredient" button is pressed.
    func addIngredientPressed()
    
    /// Call when a component has been chosen.
    func componentChosen(_ component: Meal.Component)
    
    /// Call when an amount is provided for a component.
    func componentAmountProvided(for component: Meal.Component, amount: Grams)
    
    /// Call when the submit button is pressed.
    func donePressed()
}

internal protocol MealEntryViewModelOutputs {
    
    /// Emits when we should go to the ingredient selection page.
    var goToIngredientSelection: Signal<Void, NoError> { get }
    
    /// Emits when we should go to the recipe selection page.
    var goToRecipeSelection: Signal<Void, NoError> { get }
    
    /// Emits when we need to show an alert to gather a weight for a meal component.
    var showAlertToGatherAmountForComponent: Signal<Meal.Component, NoError> { get }
    
    /// Emits when we need to insert a newly selected component into the view.
    var insertComponent: Signal<Meal.ComponentAndAmount, NoError> { get }
    
    /// Emits when we should show a submission confirmation and clear the current entry.
    var showConfirmationAndClearFields: Signal<Void, NoError> { get }
}

internal protocol MealEntryViewModelType {
    var inputs: MealEntryViewModelInputs { get }
    var outputs: MealEntryViewModelOutputs { get }
}

final class MealEntryViewModel: MealEntryViewModelInputs, MealEntryViewModelOutputs, MealEntryViewModelType {
    
    init(service: APIService = APIService()) {
        self.goToIngredientSelection = addIngredientPressedProperty.signal
        
        self.goToRecipeSelection = addRecipePressedProperty.signal
        
        self.showAlertToGatherAmountForComponent = componentChosenProperty.signal.skipNil()
        
        self.insertComponent = componentAmountProvidedProperty
            .signal
            .skipNil()
        
        let currentComponentsAndAmounts = componentAmountProvidedProperty
            .signal
            .skipNil()
            .collect()
        
        self.showConfirmationAndClearFields = donePressedProperty
            .signal
            .withJustLatest(from: currentComponentsAndAmounts)
            .map { Meal(entryDate: .init(), componentsAndAmounts: $0) }
            .flatMap(.latest, service.add(mealEntry:))
        
    }
    
    // MARK: - Inputs
    
    private let addRecipePressedProperty = MutableProperty<Void>(())
    internal func addRecipePressed() {
        self.addRecipePressedProperty.value = ()
    }
    
    private let addIngredientPressedProperty = MutableProperty<Void>(())
    internal func addIngredientPressed() {
        self.addIngredientPressedProperty.value = ()
    }
    
    private let componentChosenProperty = MutableProperty<Meal.Component?>(nil)
    internal func componentChosen(_ component: Meal.Component) {
        self.componentChosenProperty.value = component
    }
    
    private let componentAmountProvidedProperty = MutableProperty<Meal.ComponentAndAmount?>(nil)
    internal func componentAmountProvided(for component: Meal.Component, amount: Grams) {
        self.componentAmountProvidedProperty.value = (component, amount)
    }
    
    private let donePressedProperty = MutableProperty<Void>(())
    internal func donePressed() {
        self.donePressedProperty.value = ()
    }
    
    // MARK: - Outputs
    
    let goToIngredientSelection: Signal<Void, NoError>
    
    let goToRecipeSelection: Signal<Void, NoError>
    
    let showAlertToGatherAmountForComponent: Signal<Meal.Component, NoError>
    
    let insertComponent: Signal<Meal.ComponentAndAmount, NoError>
    
    let showConfirmationAndClearFields: Signal<Void, NoError>
    
    var inputs: MealEntryViewModelInputs { return self }
    var outputs: MealEntryViewModelOutputs { return self }
}
