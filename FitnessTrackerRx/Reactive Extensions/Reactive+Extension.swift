//
//  Reactive+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

#if (canImport(RxSwift) && canImport(RxCocoa))

import RxSwift
import RxCocoa

public extension Reactive where Base: UIButton {
    
    /// Shorthand for `controlEvents(.touchUpInside)`.
    public var touchUpControlEvent: ControlEvent<()> {
        return self.controlEvent(.touchUpInside)
    }
}

public extension Reactive where Base: UITextField {
    
    /// Emits a continuous stream of `Int` values, mapped from `String` input.
    public var intValues: Observable<Int?> {
        return self.text.map { Int($0 ?? "") }
    }
}

#endif
