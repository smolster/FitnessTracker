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
    public var touchUpControlEvent: Signal<Base, NoError> {
        return self.controlEvents(.touchUpInside)
    }
}
