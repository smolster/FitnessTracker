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

internal protocol TodayViewModelInputs {
    func viewWillAppear()
    func addEntryPressed()
}

internal protocol TodayViewModelOutputs {
    var showMealEntry: Observable<Void> { get }
    var today: Observable<Day?> { get }
}

internal protocol TodayViewModelType {
    var inputs: TodayViewModelInputs { get }
    var outputs: TodayViewModelOutputs { get }
}

internal final class TodayViewModel: TodayViewModelType, TodayViewModelInputs, TodayViewModelOutputs {
    
    init(service: APIServiceType = APIService()) {
        self.showMealEntry = addEntryPressedVariable.asObservable()
        
        self.today = self.viewWillAppearVariable
            .asObservable()
            .flatMapLatest { _ in
                return service.rxAllMealsByDay(in: .current)
            }
            .map { return $0.first(where: { $0.isToday }) }
        
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
    
    // MARK: - Outputs
    
    let showMealEntry: Observable<Void>
    let today: Observable<Day?>
    
    var inputs: TodayViewModelInputs { return self }
    var outputs: TodayViewModelOutputs { return self }
}
