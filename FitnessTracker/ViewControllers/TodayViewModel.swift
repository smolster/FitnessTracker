//
//  TodayViewModel.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/18/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift

internal protocol TodayViewModelInputs {
    
}

internal protocol TodayViewModelOutputs {
    
}

internal protocol TodayViewModelType {
    var inputs: TodayViewModelInputs { get }
    var outputs: TodayViewModelOutputs { get }
}

final internal class TodayViewModel: TodayViewModelType, TodayViewModelInputs, TodayViewModelOutputs {
    
    var inputs: TodayViewModelInputs { return self }
    var outputs: TodayViewModelOutputs { return self }
}
