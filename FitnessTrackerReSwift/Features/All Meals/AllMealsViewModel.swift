//
//  AllMealsViewModel.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/30/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import RxSwift

internal protocol AllMealsViewModelInputs {
    /// Call when the users selects a particular meal.
    func selected(meal: Meal)
}

internal protocol AllMealsViewModelOutputs {
    var meals: Observable<[Meal]> { get }
    var currentlySelectedMeal: Observable<Meal> { get }
}

internal protocol AllMealsViewModelType {
    var inputs: AllMealsViewModelInputs { get }
    var outputs: AllMealsViewModelOutputs { get }
}

internal final class AllMealsViewModel: AllMealsViewModelType, AllMealsViewModelInputs, AllMealsViewModelOutputs {
    
    private let store: Store<AppState>
    private let disposeBag = DisposeBag()
    
    internal init(store: Store<AppState> = Current.store) {
        self.store = store
        
        self.meals = store.observable
            .map { $0.allMeals.asLoaded! }
        
        self.currentlySelectedMeal = meals
            .map { $0.first! }
    }
    
    func selected(meal: Meal) {
        
    }
    
    let meals: Observable<[Meal]>
    let currentlySelectedMeal: Observable<Meal>
    
    var inputs: AllMealsViewModelInputs { return self }
    var outputs: AllMealsViewModelOutputs { return self }
    
}
