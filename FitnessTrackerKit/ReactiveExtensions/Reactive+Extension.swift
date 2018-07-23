//
//  Reactive+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

public extension Reactive where Base: UIButton {
    
    /// Shorthand for `controlEvents(.touchUpInside)`.
    public var touchUpControlEvent: Signal<Base, NoError> {
        return self.controlEvents(.touchUpInside)
    }
}

public extension Reactive where Base: UITextField {
    
    /// Emits a continuous stream of `Int` values, mapped from `String` input.
    public var continuousIntValues: Signal<Int?, NoError> {
        return self.continuousTextValues.mapNilToEmpty.mapToInt
    }
}
