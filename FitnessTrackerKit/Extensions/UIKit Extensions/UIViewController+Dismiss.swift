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
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.first == self {
                self.dismiss(animated: true, completion: nil)
            } else {
                navigationController.popViewController(animated: animated)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}
