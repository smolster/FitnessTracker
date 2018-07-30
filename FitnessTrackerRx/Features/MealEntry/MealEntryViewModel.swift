//
//  MealEntryViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import FitnessTrackerKit
import RxSwift

internal protocol MealEntryViewModelInputs {
    
    /// Call when "Recipe" button is pressed.
    func addRecipePressed()
    
    /// Call when "Ingredient" button is pressed.
    func addIngredientPressed()
    
    /// Call when a component has been chosen.
    func componentChosen(_ component: Meal.Component)
    
    /// Call when an amount is provided for a component.
    func componentAmountProvided(for component: Meal.Component, amount: Grams)
    
    /// Call when the submit button is pressed.
    func donePressed()
}

internal protocol MealEntryViewModelOutputs {
    
    /// Emits when we should go to the ingredient selection page.
    var goToIngredientSelection: Observable<Void> { get }
    
    /// Emits when we should go to the recipe selection page.
    var goToRecipeSelection: Observable<Void> { get }
    
    /// Emits when we need to show an alert to gather a weight for a meal component.
    var showAlertToGatherAmountForComponent: Observable<Meal.Component> { get }
    
    /// Emits when we need to insert a newly selected component into the view.
    var insertComponent: Observable<Meal.ComponentAndAmount> { get }
    
    /// Emits when we should pop the view controller.
    var pop: Observable<Meal> { get }
}

internal protocol MealEntryViewModelType {
    var inputs: MealEntryViewModelInputs { get }
    var outputs: MealEntryViewModelOutputs { get }
}

final class MealEntryViewModel: MealEntryViewModelInputs, MealEntryViewModelOutputs, MealEntryViewModelType {
    
    init(service: APIService = APIService()) {
        self.goToIngredientSelection = addIngredientPressedProperty.asObservable()
        
        self.goToRecipeSelection = addRecipePressedProperty.asObservable()
        
        self.showAlertToGatherAmountForComponent = componentChosenProperty.asObservable().skipNil()
        
        self.insertComponent = componentAmountProvidedProperty
            .asObservable()
            .skipNil()
        
        let currentComponentsAndAmounts = componentAmountProvidedProperty
            .asObservable()
            .skipNil()
            .scan([Meal.ComponentAndAmount](), accumulator: { array, new  in
                return array + [new]
            })
        
        
        self.pop = donePressedProperty
            .asObservable()
            .map { Date() }
            .withLatestFrom(currentComponentsAndAmounts, resultSelector: { ($0, $1) })
            .flatMapLatest(service.rxAddMeal(entryDate:componentsAndAmounts:))
        
    }
    
    // MARK: - Inputs
    
    private let addRecipePressedProperty = PublishSubject<Void>()
    internal func addRecipePressed() {
        self.addRecipePressedProperty.onNext(())
    }
    
    private let addIngredientPressedProperty = PublishSubject<Void>()
    internal func addIngredientPressed() {
        self.addIngredientPressedProperty.onNext(())
    }
    
    private let componentChosenProperty = PublishSubject<Meal.Component?>()
    internal func componentChosen(_ component: Meal.Component) {
        self.componentChosenProperty.onNext(component)
    }
    
    private let componentAmountProvidedProperty = PublishSubject<Meal.ComponentAndAmount?>()
    internal func componentAmountProvided(for component: Meal.Component, amount: Grams) {
        self.componentAmountProvidedProperty.onNext((component, amount))
    }
    
    private let donePressedProperty = PublishSubject<Void>()
    internal func donePressed() {
        self.donePressedProperty.onNext(())
    }
    
    // MARK: - Outputs
    
    let goToIngredientSelection: Observable<Void>
    
    let goToRecipeSelection: Observable<Void>
    
    let showAlertToGatherAmountForComponent: Observable<Meal.Component>
    
    let insertComponent: Observable<Meal.ComponentAndAmount>
    
    let pop: Observable<Meal>
    
    var inputs: MealEntryViewModelInputs { return self }
    var outputs: MealEntryViewModelOutputs { return self }
}
