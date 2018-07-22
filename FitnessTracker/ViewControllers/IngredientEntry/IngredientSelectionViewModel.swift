// 
//  IngredientSelectionViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import ReactiveSwift
import Result

internal protocol IngredientSelectionViewModelInputs {
    func viewWillAppear()
    func createNewPressed()
    func ingredientSelected(_ ingredient: Ingredient)
}

internal protocol IngredientSelectionViewModelOutputs {
    var ingredients: Signal<[Ingredient], NoError> { get }
    var goToCreateNew: Signal<Void, NoError> { get }
    var dismissIfPresented: Signal<Void, NoError> { get }
}

internal protocol IngredientSelectionViewModelType {
    var inputs: IngredientSelectionViewModelInputs { get }
    var outputs: IngredientSelectionViewModelOutputs { get }
}

internal final class IngredientSelectionViewModel: IngredientSelectionViewModelType, IngredientSelectionViewModelInputs, IngredientSelectionViewModelOutputs {
    
    init(service: APIServiceType = APIService()) {
        self.ingredients = self.viewWillAppearProperty
            .signal
            .flatMap(.latest, {
                _ in service.getAllIngredients()
            })
        
        self.goToCreateNew = self.createNewPressedProperty.signal
        
        self.dismissIfPresented = ingredientSelectedProperty
            .signal
            .skipNil()
            .mapToVoid()
    }
    
    // MARK: - Inputs
    
    private let viewWillAppearProperty = MutableProperty<Void>(())
    internal func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    private let createNewPressedProperty = MutableProperty<Void>(())
    internal func createNewPressed() {
        self.createNewPressedProperty.value = ()
    }
    
    private let ingredientSelectedProperty = MutableProperty<Ingredient?>(nil)
    internal func ingredientSelected(_ ingredient: Ingredient) {
        self.ingredientSelectedProperty.value = ingredient
    }
    
    // MARK: - Outputs
    
    let ingredients: Signal<[Ingredient], NoError>
    
    let goToCreateNew: Signal<Void, NoError>
    
    let dismissIfPresented: Signal<Void, NoError>
    
    var inputs: IngredientSelectionViewModelInputs { return self }
    var outputs: IngredientSelectionViewModelOutputs { return self }
}
