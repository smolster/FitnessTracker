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
    /// Call on viewWillAppear.
    func viewWillAppear()
    
    /// Call when the user selects a particular day.
    func selectedDay(_ day: Day)
}

internal protocol AllMealsViewModelOutputs {
    /// Emits all days.
    var days: Observable<[Day]> { get }
    
    /// Emits when we should show an alert with the given title and message.
    var showAlert: Observable<AlertStrings> { get }
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
        
        self.showAlert = selectedDaySubject
            .asObservable()
            .observeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "date-formatting"))
            .map { day in
                return (
                    day.displayDate.dateString,
                    """
                    Total Calories: \(day.totalCalories.rawValue)
                    
                    Total Macros:
                    \(day.totalMacros)
                    """
                )
            }
    }
    
    // MARK: - Inputs
    
    let viewWillAppearProperty = PublishSubject<Void>()
    internal func viewWillAppear() {
        viewWillAppearProperty.onNext(())
    }
    
    let selectedDaySubject = PublishSubject<Day>()
    internal func selectedDay(_ day: Day) {
        selectedDaySubject.onNext(day)
    }
    
    // MARK: - Outputs
    
    let days: Observable<[Day]>
    let showAlert: Observable<AlertStrings>
    
    // MARK: - Types
    
    var inputs: AllMealsViewModelInputs { return self }
    var outputs: AllMealsViewModelOutputs { return self }
    
}
