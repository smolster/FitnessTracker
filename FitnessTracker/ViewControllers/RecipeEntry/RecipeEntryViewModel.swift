// 
//  RecipeEntryViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import ReactiveSwift

internal protocol RecipeEntryViewModelInputs {
//    func ingredientAdded(_ ingredient: Ingredient)
    func nameUpdated(to newName: String)
    func donePressed()
}

internal protocol RecipeEntryViewModelOutputs {
    
}

internal protocol RecipeEntryViewModelType {
    var inputs: RecipeEntryViewModelInputs { get }
    var outputs: RecipeEntryViewModelOutputs { get }
}

internal final class RecipeEntryViewModel: RecipeEntryViewModelType, RecipeEntryViewModelInputs, RecipeEntryViewModelOutputs {
    
    // MARK: - Inputs
    
    let nameTextProperty = MutableProperty<String>("")
    func nameUpdated(to newName: String) {
        nameTextProperty.value = ""
    }
    
    let donePressedProperty = MutableProperty<Void>(())
    func donePressed() {
        self.donePressedProperty.value = ()
    }
    
    // MARK: - Outputs
    
    var inputs: RecipeEntryViewModelInputs { return self }
    var outputs: RecipeEntryViewModelOutputs { return self }
}
