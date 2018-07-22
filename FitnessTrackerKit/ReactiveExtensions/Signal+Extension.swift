//
//  Signal+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

public extension Signal where Value == String? {
    /// Maps `nil` case to empty `String`.
    public var mapNilToEmpty: Signal<String, Error> {
        return self.map { $0 ?? "" }
    }
}

public extension Signal where Value == String {
    public var mapToInt: Signal<Int?, Error> {
        return self.map(Int.init)
    }
}

public extension Signal where Value == Int? {
    public var mapNilToZero: Signal<Int, Error> {
        return self.map { $0 ?? 0 }
    }
}

public extension Signal {
    public func withJustLatest<T>(from signal: Signal<T, NoError>) -> Signal<T, Error> {
        return self.withLatest(from: signal).map { $0.1 }
    }
    
    public func mapToVoid() -> Signal<Void, Error> {
        return self.map { _ in return () }
    }
    
    @discardableResult
    public func observeOnUI() -> Signal<Value, Error> {
        return self.observe(on: UIScheduler())
    }
}
