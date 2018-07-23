// 
//  RecipeCreationViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import ReactiveSwift
import Result

internal protocol RecipeCreationViewModelInputs {
    func nameUpdated(to newName: String)
    func ingredientSelected(_ ingredient: Ingredient)
    func amountSelected(for ingredient: Ingredient, amount: Grams)
    func donePressed()
}

internal protocol RecipeCreationViewModelOutputs {
    var showAlertToGatherAmountOfIngredient: Signal<Ingredient, NoError> { get }
    var doneButtonEnabled: Signal<Bool, NoError> { get }
    var showConfirmationAndDismiss: Signal<Void, NoError> { get }
}

internal protocol RecipeCreationViewModelType {
    var inputs: RecipeCreationViewModelInputs { get }
    var outputs: RecipeCreationViewModelOutputs { get }
}

internal final class RecipeCreationViewModel: RecipeCreationViewModelType, RecipeCreationViewModelInputs, RecipeCreationViewModelOutputs {
    
    init(service: APIServiceType = APIService()) {
        self.showAlertToGatherAmountOfIngredient = ingredientSelectedProperty
            .signal
            .skipNil()
        
        let currentIngredientsAndAmounts = amountSelectedProperty
            .signal
            .skipNil()
            .collect()
            .logEvents()
        
        self.doneButtonEnabled = Signal
            .combineLatest(
                nameTextProperty.signal,
                currentIngredientsAndAmounts
            )
            .map { $0.0.isNotEmpty && $0.1.isNotEmpty }
        
        let currentRecipe = Signal
            .combineLatest(
                nameTextProperty.signal,
                currentIngredientsAndAmounts
            )
            .map(Recipe.init)
            .logEvents()
        
        self.showConfirmationAndDismiss = self.donePressedProperty
            .signal
            .logEvents()
            .withJustLatest(from: currentRecipe)
            .logEvents()
            .flatMap(.latest) { recipe in
                service.add(recipe: recipe)
            }
    }
    
    // MARK: - Inputs
    
    private let nameTextProperty = MutableProperty<String>("")
    internal func nameUpdated(to newName: String) {
        nameTextProperty.value = newName
    }
    
    private let ingredientSelectedProperty = MutableProperty<Ingredient?>(nil)
    internal func ingredientSelected(_ ingredient: Ingredient) {
        self.ingredientSelectedProperty.value = ingredient
    }
    
    private let amountSelectedProperty = MutableProperty<Recipe.IngredientAndAmount?>(nil)
    internal func amountSelected(for ingredient: Ingredient, amount: Grams) {
        self.amountSelectedProperty.value = (ingredient, amount)
    }
    
    private let donePressedProperty = MutableProperty<Void>(())
    internal func donePressed() {
        self.donePressedProperty.value = ()
    }
    
    // MARK: - Outputs
    
    let showAlertToGatherAmountOfIngredient: Signal<Ingredient, NoError>
    
    let doneButtonEnabled: Signal<Bool, NoError>
    
    let showConfirmationAndDismiss: Signal<Void, NoError>
    
    var inputs: RecipeCreationViewModelInputs { return self }
    var outputs: RecipeCreationViewModelOutputs { return self }
}
