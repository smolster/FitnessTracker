// 
//  MealComponentSelectionViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import RxSwift

internal protocol MealComponentSelectionViewModelInputs {
    /// Call on viewWillAppear, with the `kind`.
    func viewWillAppear(with kind: Meal.Component.Kind)
    
    /// Call when the user taps "Create New".
    func createNewPressed()
    
    /// Call when the user selects a component.
    func componentSelected(_ component: Meal.Component)
}

internal protocol MealComponentSelectionViewModelOutputs {
    
    /// Emits all available components.
    var components: Observable<[Meal.Component]> { get }
    
    /// Emits when we should go to the "Create New" flow.
    var goToCreateNew: Observable<Meal.Component.Kind> { get }
    
    /// Emits when we should dismiss this screen.
    var dismissIfPresented: Observable<Void> { get }
}

internal protocol MealComponentSelectionViewModelType {
    var inputs: MealComponentSelectionViewModelInputs { get }
    var outputs: MealComponentSelectionViewModelOutputs { get }
}

internal final class MealComponentSelectionViewModel: MealComponentSelectionViewModelType, MealComponentSelectionViewModelInputs, MealComponentSelectionViewModelOutputs {
    
    init(service: APIServiceType = APIService()) {
        
        let kind = viewWillAppearProperty
                .asObservable()
                .skipNil()
        
        self.components = kind
            .flatMapLatest { kind -> Observable<[Meal.Component]> in
                switch kind {
                case .ingredient:
                    return service.rxAllIngredients().map { $0.map { Meal.Component.ingredient($0) } }
                case .recipe:
                    return service.rxAllRecipes().map { $0.map { Meal.Component.recipe($0) } }
                }
            }
        
        self.goToCreateNew = self.createNewPressedProperty
            .asObservable()
            .withLatestFrom(kind)
        
        self.dismissIfPresented = componentSelectedProperty
            .asObservable()
            .skipNil()
            .mapToVoid()
    }
    
    // MARK: - Inputs
    
    private let viewWillAppearProperty = PublishSubject<Meal.Component.Kind?>()
    internal func viewWillAppear(with kind: Meal.Component.Kind) {
        self.viewWillAppearProperty.onNext(kind)
    }
    
    private let createNewPressedProperty = PublishSubject<Void>()
    internal func createNewPressed() {
        self.createNewPressedProperty.onNext(())
    }
    
    private let componentSelectedProperty = PublishSubject<Meal.Component?>()
    internal func componentSelected(_ component: Meal.Component) {
        self.componentSelectedProperty.onNext(component)
    }
    
    // MARK: - Outputs
    
    let components: Observable<[Meal.Component]>
    
    let goToCreateNew: Observable<Meal.Component.Kind>
    
    let dismissIfPresented: Observable<Void>
    
    var inputs: MealComponentSelectionViewModelInputs { return self }
    var outputs: MealComponentSelectionViewModelOutputs { return self }
}
