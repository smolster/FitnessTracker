//
//  UIControl+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import UIKit

public class Bucket {
    private var actions: [TargetAction] = []
    internal func store(action: TargetAction) {
        self.actions.append(action)
    }
    public init() { }
}

public class TargetAction {
    internal let action: () -> Void
    internal init(_ action: @escaping () -> Void) {
        self.action = action
    }
    @objc internal func performAction() { self.action() }
    
    public func store(in bucket: Bucket) {
        bucket.store(action: self)
    }
}

public protocol Control { }
public extension Control where Self: UIControl {
    public func addAction(for controlEvents: UIControlEvents, _ action: @escaping (Self) -> Void) -> TargetAction {
        let targetAction = TargetAction { action(self) }
        self.addTarget(targetAction, action: #selector(TargetAction.performAction), for: controlEvents)
        return targetAction
    }
}
extension UIControl: Control { }
