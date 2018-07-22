// 
//  ChooseRecipeViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import ReactiveSwift
import Result

internal protocol ChooseRecipeViewModelInputs {
    func viewWillAppear()
    func newRecipeCreated(_ recipe: Recipe)
}

internal protocol ChooseRecipeViewModelOutputs {
    var existingRecipes: Signal<[Recipe], NoError> { get }
}

internal protocol ChooseRecipeViewModelType {
    var inputs: ChooseRecipeViewModelInputs { get }
    var outputs: ChooseRecipeViewModelOutputs { get }
}

internal final class ChooseRecipeViewModel: ChooseRecipeViewModelType, ChooseRecipeViewModelInputs, ChooseRecipeViewModelOutputs {
    
    init(service: APIServiceType = APIService()) {
        self.existingRecipes = viewWillAppearProperty
            .signal
            .flatMap(.latest, { _ in service.getAllRecipes() })
    }
    
    // MARK: - Inputs
    
    let viewWillAppearProperty = MutableProperty<Void>(())
    internal func viewWillAppear() {
        self.viewWillAppearProperty.value = ()
    }
    
    let newRecipeCreatedProperty = MutableProperty<Recipe?>(nil)
    internal func newRecipeCreated(_ recipe: Recipe) {
        self.newRecipeCreatedProperty.value = recipe
    }
    
    // MARK: - Outputs
    
    let existingRecipes: Signal<[Recipe], NoError>
    
    var inputs: ChooseRecipeViewModelInputs { return self }
    var outputs: ChooseRecipeViewModelOutputs { return self }
}
