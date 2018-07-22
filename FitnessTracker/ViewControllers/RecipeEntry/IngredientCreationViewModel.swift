// 
//  IngredientCreationViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import ReactiveSwift

internal protocol IngredientCreationViewModelInputs {
    
}

internal protocol IngredientCreationViewModelOutputs {
    
}

internal protocol IngredientCreationViewModelType {
    var inputs: IngredientCreationViewModelInputs { get }
    var outputs: IngredientCreationViewModelOutputs { get }
}

internal final class IngredientCreationViewModel: IngredientCreationViewModelType, IngredientCreationViewModelInputs, IngredientCreationViewModelOutputs {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    var inputs: IngredientCreationViewModelInputs { return self }
    var outputs: IngredientCreationViewModelOutputs { return self }
}
