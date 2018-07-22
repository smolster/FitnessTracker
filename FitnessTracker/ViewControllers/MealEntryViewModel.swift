//
//  MealEntryViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import FitnessTrackerKit
import ReactiveSwift
import Result

internal protocol MealEntryViewModelInputs {
    /// Call when the submit button is pressed
    func submitPressed()
    func proteinTextFieldChanged(_ newText: String?)
    func carbsTextFieldChanged(_ newText: String?)
    func fatFieldTextChanged(_ newText: String?)
}

internal protocol MealEntryViewModelOutputs {
//    var showConfirmationAndClearFields: Signal<Void, NoError> { get }
}

internal protocol MealEntryViewModelType {
    var inputs: MealEntryViewModelInputs { get }
    var outputs: MealEntryViewModelOutputs { get }
}

final class MealEntryViewModel: MealEntryViewModelInputs, MealEntryViewModelOutputs, MealEntryViewModelType {
    
    let service: APIService
    init(service: APIService = APIService()) {
        self.service = service
        
        let currentMacros = Signal.combineLatest(
                proteinTextProperty.signal.mapNilToEmpty.mapToInt.mapNilToZero,
                carbsTextProperty.signal.mapNilToEmpty.mapToInt.mapNilToZero,
                fatTextProperty.signal.mapNilToEmpty.mapToInt.mapNilToZero
            )
            .map { (Grams(rawValue: $0),  Grams(rawValue: $1), Grams(rawValue: $2)) }
            .map(MacroCount.init)
        
        self.submitProperty.signal
            .withLatest(from: currentMacros)
            .observeValues { _, macros in
                let meal = Meal(entryDate: Date(), macros: macros)
            }
    }
    
    // MARK: - Inputs
    
    let submitProperty = MutableProperty<Void>(())
    func submitPressed() {
        self.submitProperty.value = ()
    }
    
    let proteinTextProperty = MutableProperty<String?>(nil)
    func proteinTextFieldChanged(_ newText: String?) {
        proteinTextProperty.value = newText
    }
    
    let carbsTextProperty = MutableProperty<String?>(nil)
    func carbsTextFieldChanged(_ newText: String?) {
        carbsTextProperty.value = newText
    }
    
    let fatTextProperty = MutableProperty<String?>(nil)
    func fatFieldTextChanged(_ newText: String?) {
        fatTextProperty.value = newText
    }
    
    // MARK: - Outputs
    
//    let showConfirmationAndClearFields: Signal<Void, NoError>
    
    var inputs: MealEntryViewModelInputs { return self }
    var outputs: MealEntryViewModelOutputs { return self }
}
