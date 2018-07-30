//
//  TargetAction.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

internal final class TargetAction {
    let action: () -> Void
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    @objc internal func performAction() {
        self.action()
    }
    
    public func storeReference(in collection: inout [TargetAction]) {
        collection.append(self)
    }
}

extension UIControl {
    internal func addAction(for controlEvents: UIControlEvents, action: @escaping () -> Void) -> TargetAction {
        let targetAction = TargetAction(action)
        self.addTarget(targetAction, action: #selector(TargetAction.performAction), for: controlEvents)
        return targetAction
    }
}
