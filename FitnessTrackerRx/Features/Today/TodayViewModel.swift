// 
//  TodayViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/25/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import FitnessTrackerKit
import RxSwift
import RxCocoa

typealias AlertStrings = (title: String?, message: String)
typealias MealWithDisplayTime = (meal: Meal, displayTime: String)
typealias DayWithMealDisplayTimes = (day: Day, mealsWithDisplayTimes: [MealWithDisplayTime])

internal protocol TodayViewModelInputs {
    
    /// Call on viewWillAppear.
    func viewWillAppear()
    
    /// Call when user taps "Add Entry".
    func addEntryPressed()
    
    /// Call when the user taps on a meal they have already had.
    func selectedMeal(_ meal: Meal)
}

internal protocol TodayViewModelOutputs {
    /// Emits when we should show the meal entry flow.
    var showMealEntry: Observable<Void> { get }
    
    /// Emits today's meals and time strings.
    var today: Observable<DayWithMealDisplayTimes?> { get }
    
    /// Emits when we should show an alert with a given title & message.
    var showAlertWithMessage: Observable<AlertStrings> { get }
}

internal protocol TodayViewModelType {
    var inputs: TodayViewModelInputs { get }
    var outputs: TodayViewModelOutputs { get }
}

internal final class TodayViewModel: TodayViewModelType, TodayViewModelInputs, TodayViewModelOutputs {
    
    init(service: APIServiceType = APIService()) {
        self.showMealEntry = addEntryPressedVariable.asObservable()
        
        func dayWithMealDisplayTimes(from day: Day?) -> DayWithMealDisplayTimes? {
            guard let day = day else { return nil }
            let mealsWithDisplayTimes = day.allMeals.reduce(into: [MealWithDisplayTime]()) { result, meal in
                let timeString = DateCacher.shared.string(from: meal.entryDate, using: .hMMA(.current))
                result.append((meal, timeString))
            }
            
            return (day, mealsWithDisplayTimes)
        }
        
        self.today = self.viewWillAppearVariable
            .asObservable()
            .flatMapLatest { _ in
                return service.rxAllMealsByDay(in: .current)
            }
            .map { return $0.first(where: { $0.isToday }) }
            .map(dayWithMealDisplayTimes)
        
        self.showAlertWithMessage = self.selectedMealVariable
            .asObservable()
            .observeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "date-formatting"))
            .map { meal in
                (
                    DateCacher.shared.string(from: meal.entryDate, using: .dateTime(.current)),
                    """
                    Total Calories: \(meal.calories.rawValue)
                    
                    Total Macros:
                    \(meal.totalMacros.description)
                    """
                )
            }
        
    }
    
    // MARK: - Inputs
    private let viewWillAppearVariable = PublishSubject<Void>()
    internal func viewWillAppear() {
        self.viewWillAppearVariable.onNext(())
    }
    
    private let addEntryPressedVariable = PublishSubject<Void>()
    internal func addEntryPressed() {
        addEntryPressedVariable.onNext(())
    }
    
    private let selectedMealVariable = PublishSubject<Meal>()
    internal func selectedMeal(_ meal: Meal) {
        selectedMealVariable.onNext(meal)
    }
    
    // MARK: - Outputs
    
    let showMealEntry: Observable<Void>
    let today: Observable<DayWithMealDisplayTimes?>
    let showAlertWithMessage: Observable<AlertStrings>
    
    var inputs: TodayViewModelInputs { return self }
    var outputs: TodayViewModelOutputs { return self }
}
