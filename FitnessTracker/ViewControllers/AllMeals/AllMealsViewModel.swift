//
//  AllMealsViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import FitnessTrackerKit

internal protocol AllMealsViewModelInputs {
    /// Called on viewWillAppear.
    func viewWillAppear()
}

internal protocol AllMealsViewModelOutputs {
    /// Outputs a signal when the days are loaded.
    var days: Signal<[Day], NoError> { get }
}

internal protocol AllMealsViewModelType {
    var inputs: AllMealsViewModelInputs { get }
    var outputs: AllMealsViewModelOutputs { get }
}

final internal class AllMealsViewModel: AllMealsViewModelType, AllMealsViewModelInputs, AllMealsViewModelOutputs {
    
    private let service: APIService
    
    init(service: APIService = APIService()) {
        self.service = service
        self.days = viewWillAppearProperty
            .signal
            .flatMap(.latest, { _ in service.getAllMealsByDay(in: .current)})
    }
    
    var inputs: AllMealsViewModelInputs { return self }
    var outputs: AllMealsViewModelOutputs { return self }
    
    // MARK: - Inputs
    
    let viewWillAppearProperty = MutableProperty<Void>(())
    func viewWillAppear() {
        viewWillAppearProperty.value = ()
    }
    
    // MARK: - Outputs
    
    let days: Signal<[Day], NoError>
}
