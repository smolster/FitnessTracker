//
//  ObserverType+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/26/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

#if canImport(RxSwift)

import RxSwift

extension ObserverType {
    public func onNextAndComplete(with value: E) {
        self.onNext(value)
        self.onCompleted()
    }
}

#endif
