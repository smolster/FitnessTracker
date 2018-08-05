//
//  ObservableType+Extension.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/31/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import RxSwift

internal extension ObservableType {
    internal func subscribeToNext(_ onNext: @escaping (Self.E) -> Void) -> Disposable {
        return self.subscribe(onNext: onNext)
    }
}
