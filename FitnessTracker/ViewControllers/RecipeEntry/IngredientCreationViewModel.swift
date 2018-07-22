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
import Result

internal protocol IngredientCreationViewModelInputs {
    func setName(_ name: String)
    func setProteinGrams(_ grams: Int?)
    func setCarbsGrams(_ grams: Int?)
    func setFatGrams(_ grams: Int?)
    
    func donePressed()
}

internal protocol IngredientCreationViewModelOutputs {
    var doneButtonEnabled: Signal<Bool, NoError> { get }
    var dismiss: Signal<Void, NoError> { get }
}

internal protocol IngredientCreationViewModelType {
    var inputs: IngredientCreationViewModelInputs { get }
    var outputs: IngredientCreationViewModelOutputs { get }
}

internal final class IngredientCreationViewModel: IngredientCreationViewModelType, IngredientCreationViewModelInputs, IngredientCreationViewModelOutputs {
    
    init(service: APIService = APIService()) {
        self.doneButtonEnabled = Signal.combineLatest(
                proteinGramsProperty.signal,
                carbsGramsProperty.signal,
                fatGramsProperty.signal,
                nameProperty.signal
            )
            .map {
                $0.0 != nil && $0.1 != nil && $0.2 != nil && ($0.3 != nil && $0.3 != "")
            }
        
        self.dismiss = dismissProperty.signal
        
        let latestIngredient = Signal.combineLatest(
                proteinGramsProperty.signal,
                carbsGramsProperty.signal,
                fatGramsProperty.signal
            )
            .map { ($0.0 ?? .zero, $0.1 ?? .zero, $0.2 ?? .zero) }
            .map(Macros.init)
            .combineLatest(with: nameProperty.signal.skipNil())
            .map { ($1, $0) }
            .map(Ingredient.init)
        
        donePressedProperty.signal
            .withJustLatest(from: latestIngredient)
            .observeValues { ingredient in
                service.add(ingredient: ingredient)
                    .startWithValues {
                        self.dismissProperty.value = ()
                    }
            }
    }
    
    // MARK: - Inputs
    
    private let nameProperty = MutableProperty<String?>(nil)
    internal func setName(_ name: String) {
        self.nameProperty.value = name
    }
    
    private let proteinGramsProperty = MutableProperty<Grams?>(nil)
    internal func setProteinGrams(_ grams: Int?) {
        self.proteinGramsProperty.value = makeGrams(from: grams)
    }
    
    private let carbsGramsProperty = MutableProperty<Grams?>(nil)
    internal func setCarbsGrams(_ grams: Int?) {
        self.carbsGramsProperty.value = makeGrams(from: grams)
    }
    
    private let fatGramsProperty = MutableProperty<Grams?>(nil)
    internal func setFatGrams(_ grams: Int?) {
        self.fatGramsProperty.value = makeGrams(from: grams)
    }
    
    private let donePressedProperty = MutableProperty<Void>(())
    internal func donePressed() {
        self.donePressedProperty.value = ()
    }
    
    // MARK: - Outputs
    
    let doneButtonEnabled: Signal<Bool, NoError>
    
    private let dismissProperty = MutableProperty<Void>(())
    let dismiss: Signal<Void, NoError>
    
    var inputs: IngredientCreationViewModelInputs { return self }
    var outputs: IngredientCreationViewModelOutputs { return self }
}

private func makeGrams(from optInteger: Int?) -> Grams? {
    guard let integer = optInteger else { return nil }
    return .init(rawValue: integer)
}

extension Signal {
    func withJustLatest<T>(from signal: Signal<T, NoError>) -> Signal<T, Error> {
        return self.withLatest(from: signal).map { $0.1 }
    }
}
