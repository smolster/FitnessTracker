// 
//  RecipeCreationViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import RxSwift

internal protocol RecipeCreationViewModelInputs {
    func nameUpdated(to newName: String)
    func ingredientSelected(_ ingredient: Ingredient)
    func amountSelected(for ingredient: Ingredient, amount: Grams)
    func donePressed()
}

internal protocol RecipeCreationViewModelOutputs {
    var showAlertToGatherAmountOfIngredient: Observable<Ingredient> { get }
    var doneButtonEnabled: Observable<Bool> { get }
    var showConfirmationAndDismiss: Observable<Recipe> { get }
}

internal protocol RecipeCreationViewModelType {
    var inputs: RecipeCreationViewModelInputs { get }
    var outputs: RecipeCreationViewModelOutputs { get }
}

internal final class RecipeCreationViewModel: RecipeCreationViewModelType, RecipeCreationViewModelInputs, RecipeCreationViewModelOutputs {
    
    init(service: APIServiceType = APIService()) {
        self.showAlertToGatherAmountOfIngredient = ingredientSelectedProperty
            .asObservable()
            .skipNil()
        
        let currentIngredientsAndAmounts = amountSelectedProperty
            .asObservable()
            .skipNil()
            .gather()
        
        let currentNameAndIngredients = Observable
            .combineLatest(
                nameTextProperty.asObservable(),
                currentIngredientsAndAmounts
            )
    
        self.doneButtonEnabled = currentNameAndIngredients
            .map { $0.0.isNotEmpty && $0.1.isNotEmpty }
        
        self.showConfirmationAndDismiss = self.donePressedProperty
            .asObservable()
            .withLatestFrom(currentNameAndIngredients)
            .flatMapLatest(service.rxAddRecipe(name:ingredientsAndAmounts:))
        
    }
    
    // MARK: - Inputs
    
    private let nameTextProperty = PublishSubject<String>()
    internal func nameUpdated(to newName: String) {
        nameTextProperty.onNext(newName)
    }
    
    private let ingredientSelectedProperty = PublishSubject<Ingredient?>()
    internal func ingredientSelected(_ ingredient: Ingredient) {
        self.ingredientSelectedProperty.onNext(ingredient)
    }
    
    private let amountSelectedProperty = PublishSubject<Recipe.IngredientAndAmount?>()
    internal func amountSelected(for ingredient: Ingredient, amount: Grams) {
        self.amountSelectedProperty.onNext((ingredient, amount))
    }
    
    private let donePressedProperty = PublishSubject<Void>()
    internal func donePressed() {
        self.donePressedProperty.onNext(())
    }
    
    // MARK: - Outputs
    
    let showAlertToGatherAmountOfIngredient: Observable<Ingredient>
    
    let doneButtonEnabled: Observable<Bool>
    
    let showConfirmationAndDismiss: Observable<Recipe>
    
    var inputs: RecipeCreationViewModelInputs { return self }
    var outputs: RecipeCreationViewModelOutputs { return self }
}
