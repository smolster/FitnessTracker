//
//  AllMealsViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import RxSwift

internal protocol AllMealsViewModelInputs {
    /// Called on viewWillAppear.
    func viewWillAppear()
}

internal protocol AllMealsViewModelOutputs {
    /// Outputs a signal when the days are loaded.
    var days: Observable<[Day]> { get }
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
            .asObservable()
            .flatMapLatest { service.rxGetAllMealsByDay(in: .current)}
    }
    
    var inputs: AllMealsViewModelInputs { return self }
    var outputs: AllMealsViewModelOutputs { return self }
    
    // MARK: - Inputs
    
    let viewWillAppearProperty = PublishSubject<Void>()
    func viewWillAppear() {
        viewWillAppearProperty.onNext(())
    }
    
    // MARK: - Outputs
    
    let days: Observable<[Day]>
}
