//
//  UIViewController+Dismiss.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/23/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public extension UIViewController {
    public func dismissOrPop(animated: Bool = true) {
        if self.isBeingPresented {
            self.dismiss(animated: true, completion: nil)
        } else if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
