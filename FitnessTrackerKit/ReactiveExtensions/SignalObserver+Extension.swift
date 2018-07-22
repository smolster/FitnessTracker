//
//  SignalObserver+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import ReactiveSwift

public extension Signal.Observer {
    public func sendAndComplete(with value: Value) {
        send(value: value)
        sendCompleted()
    }
}
