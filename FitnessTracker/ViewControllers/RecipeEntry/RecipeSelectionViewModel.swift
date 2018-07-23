// 
//  RecipeSelectionViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import ReactiveSwift
import Result

internal protocol RecipeSelectionViewModelInputs {
    
}

internal protocol RecipeSelectionViewModelOutputs {
    
}

internal protocol RecipeSelectionViewModelType {
    var inputs: RecipeSelectionViewModelInputs { get }
    var outputs: RecipeSelectionViewModelOutputs { get }
}

internal final class RecipeSelectionViewModel: RecipeSelectionViewModelType, RecipeSelectionViewModelInputs, RecipeSelectionViewModelOutputs {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    var inputs: RecipeSelectionViewModelInputs { return self }
    var outputs: RecipeSelectionViewModelOutputs { return self }
}
