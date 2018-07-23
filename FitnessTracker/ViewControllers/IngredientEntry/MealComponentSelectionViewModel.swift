// 
//  MealComponentSelectionViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import ReactiveSwift
import Result

internal protocol MealComponentSelectionViewModelInputs {
    func viewWillAppear(with kind: Meal.Component.Kind)
    func createNewPressed()
    func componentSelected(_ component: Meal.Component)
}

internal protocol MealComponentSelectionViewModelOutputs {
    var components: Signal<[Meal.Component], NoError> { get }
    var goToCreateNew: Signal<Meal.Component.Kind, NoError> { get }
    var dismissIfPresented: Signal<Void, NoError> { get }
}

internal protocol MealComponentSelectionViewModelType {
    var inputs: MealComponentSelectionViewModelInputs { get }
    var outputs: MealComponentSelectionViewModelOutputs { get }
}

internal final class MealComponentSelectionViewModel: MealComponentSelectionViewModelType, MealComponentSelectionViewModelInputs, MealComponentSelectionViewModelOutputs {
    
    init(service: APIServiceType = APIService()) {
        
        let kind = viewWillAppearProperty.signal.skipNil()
        
        self.components = kind
            .flatMap(.latest, { kind -> SignalProducer<[Meal.Component], NoError> in
                switch kind {
                case .ingredient:
                    return service.getAllIngredients().map { $0.map { Meal.Component.ingredient($0) } }
                case .recipe:
                    return service.getAllRecipes().map { $0.map { Meal.Component.recipe($0) }}
                }
            })
        
        self.goToCreateNew = self.createNewPressedProperty
            .signal
            .withJustLatest(from: kind)
        
        self.dismissIfPresented = componentSelectedProperty
            .signal
            .skipNil()
            .mapToVoid()
    }
    
    // MARK: - Inputs
    
    private let viewWillAppearProperty = MutableProperty<Meal.Component.Kind?>(nil)
    internal func viewWillAppear(with kind: Meal.Component.Kind) {
        self.viewWillAppearProperty.value = kind
    }
    
    private let createNewPressedProperty = MutableProperty<Void>(())
    internal func createNewPressed() {
        self.createNewPressedProperty.value = ()
    }
    
    private let componentSelectedProperty = MutableProperty<Meal.Component?>(nil)
    internal func componentSelected(_ component: Meal.Component) {
        self.componentSelectedProperty.value = component
    }
    
    // MARK: - Outputs
    
    let components: Signal<[Meal.Component], NoError>
    
    let goToCreateNew: Signal<Meal.Component.Kind, NoError>
    
    let dismissIfPresented: Signal<Void, NoError>
    
    var inputs: MealComponentSelectionViewModelInputs { return self }
    var outputs: MealComponentSelectionViewModelOutputs { return self }
}
