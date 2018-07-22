//
//  MealEntryViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit
import ReactiveSwift
import ReactiveCocoa
import Result

extension Reactive where Base: UIButton {
    var touchUpControlEvent: Signal<Base, NoError> {
        return self.controlEvents(.touchUpInside)
    }
}

extension Signal where Value == String? {
    var mapNilToEmpty: Signal<String, Error> {
        return self.map { $0 ?? "" }
    }
}

extension Signal where Value == String {
    var mapToInt: Signal<Int?, Error> {
        return self.map { Int($0) }
    }
}

extension Signal where Value == Int? {
    var mapNilToZero: Signal<Int, Error> {
        return self.map { $0 ?? 0 }
    }
}

class MealEntryViewController: UIViewController {
    
    let (lifetime, token) = Lifetime.make()
    
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var proteinField: UITextField!
    @IBOutlet private weak var carbsField: UITextField!
    @IBOutlet private weak var fatField: UITextField!
    
    let viewModel: MealEntryViewModelType = MealEntryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        proteinField.reactive
            .continuousTextValues
            .observeValues(self.viewModel.inputs.proteinTextFieldChanged(_:))
        
        carbsField.reactive
            .continuousTextValues
            .observeValues(self.viewModel.inputs.carbsTextFieldChanged(_:))
        
        fatField.reactive
            .continuousTextValues
            .observeValues(self.viewModel.inputs.fatFieldTextChanged(_:))
        
        submitButton.reactive
            .touchUpControlEvent
            .observeValues { _ in
                self.viewModel.inputs.submitPressed()
            }
        
    }

}
