// 
//  ChooseRecipeViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import RxSwift

internal protocol ChooseRecipeViewModelInputs {
    func viewWillAppear()
    func newRecipeCreated(_ recipe: Recipe)
}

internal protocol ChooseRecipeViewModelOutputs {
    var existingRecipes: Observable<[Recipe]> { get }
}

internal protocol ChooseRecipeViewModelType {
    var inputs: ChooseRecipeViewModelInputs { get }
    var outputs: ChooseRecipeViewModelOutputs { get }
}

internal final class ChooseRecipeViewModel: ChooseRecipeViewModelType, ChooseRecipeViewModelInputs, ChooseRecipeViewModelOutputs {
    
    init(service: APIServiceType = APIService()) {
        self.existingRecipes = viewWillAppearProperty
            .asObservable()
            .flatMap {
                return service.rxAllRecipes()
            }
    }
    
    // MARK: - Inputs
    
    let viewWillAppearProperty = PublishSubject<Void>()
    internal func viewWillAppear() {
        self.viewWillAppearProperty.onNext(())
    }
    
    let newRecipeCreatedProperty = PublishSubject<Recipe?>()
    internal func newRecipeCreated(_ recipe: Recipe) {
        self.newRecipeCreatedProperty.onNext(recipe)
    }
    
    // MARK: - Outputs
    
    let existingRecipes: Observable<[Recipe]>
    
    var inputs: ChooseRecipeViewModelInputs { return self }
    var outputs: ChooseRecipeViewModelOutputs { return self }
}
