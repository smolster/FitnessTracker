// 
//  IngredientCreationViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import RxSwift

internal protocol IngredientCreationViewModelInputs {
    
    /// Call when the name changes.
    func setName(_ name: String)
    
    /// Call when the protein entry changes.
    func setProteinGrams(_ grams: Int?)
    
    /// Call when the carbs entry changes.
    func setCarbsGrams(_ grams: Int?)
    
    /// Call when the fat entry changes.
    func setFatGrams(_ grams: Int?)
    
    /// Call when the user taps the "Done" button.
    func donePressed()
}

internal protocol IngredientCreationViewModelOutputs {
    /// Emits whether or not the done button should be enabled.
    var doneButtonEnabled: Observable<Bool> { get }
    
    /// Emits when we should dismiss the screen.
    var dismiss: Observable<Ingredient> { get }
}

internal protocol IngredientCreationViewModelType {
    var inputs: IngredientCreationViewModelInputs { get }
    var outputs: IngredientCreationViewModelOutputs { get }
}

internal final class IngredientCreationViewModel: IngredientCreationViewModelType, IngredientCreationViewModelInputs, IngredientCreationViewModelOutputs {
    
    init(service: APIService = APIService()) {
        self.doneButtonEnabled = Observable.combineLatest(
                proteinGramsProperty.asObservable(),
                carbsGramsProperty.asObservable(),
                fatGramsProperty.asObservable(),
                nameProperty.asObservable()
            )
            .map {
                $0.0 != nil && $0.1 != nil && $0.2 != nil && ($0.3 != nil && $0.3 != "")
            }
        
        let latestNameAndMacros = Observable.combineLatest(
                proteinGramsProperty.asObservable().map { $0 ?? .zero },
                carbsGramsProperty.asObservable().map { $0 ?? .zero },
                fatGramsProperty.asObservable().map { $0 ?? .zero }
            )
            .map(MacroCount.init)
            .withLatestFrom(nameProperty.asObservable().skipNil(), resultSelector: { ($1, $0) })
        
        self.dismiss = donePressedProperty
            .asObservable()
            .withLatestFrom(latestNameAndMacros)
            .flatMapLatest(service.rxAddIngredient(name:macrosIn100g:))
    }
    
    // MARK: - Inputs
    
    private let nameProperty = PublishSubject<String?>()
    internal func setName(_ name: String) {
        self.nameProperty.onNext(name)
    }
    
    private let proteinGramsProperty = PublishSubject<Grams?>()
    internal func setProteinGrams(_ grams: Int?) {
        self.proteinGramsProperty.onNext(makeGrams(from: grams))
    }
    
    private let carbsGramsProperty = PublishSubject<Grams?>()
    internal func setCarbsGrams(_ grams: Int?) {
        self.carbsGramsProperty.onNext(makeGrams(from: grams))
    }
    
    private let fatGramsProperty = PublishSubject<Grams?>()
    internal func setFatGrams(_ grams: Int?) {
        self.fatGramsProperty.onNext(makeGrams(from: grams))
    }
    
    private let donePressedProperty = PublishSubject<Void>()
    internal func donePressed() {
        self.donePressedProperty.onNext(())
    }
    
    // MARK: - Outputs
    
    let doneButtonEnabled: Observable<Bool>
    
    let dismiss: Observable<Ingredient>
    
    var inputs: IngredientCreationViewModelInputs { return self }
    var outputs: IngredientCreationViewModelOutputs { return self }
}

private func makeGrams(from optInteger: Int?) -> Grams? {
    guard let integer = optInteger else { return nil }
    return .init(rawValue: integer)
}
