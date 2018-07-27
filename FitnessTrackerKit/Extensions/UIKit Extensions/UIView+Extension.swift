//
//  UIView+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

extension UIView {
    /**
     Adds `subviews` to self, optionally setting `translatesAutoresizingMaskIntoConstraints` on each element of `subviews`.
     
     - Parameters:
        - subviews: The subviews to add.
        - turnOffTranslatesAutoresizingMask: Whether or not to set `translatesAutoresizingMaskIntoConstraints` to false on each subview. Default is `nil`, which will not set the value.
     */
    public func addSubviews(_ subviews: [UIView], turnOffTranslatesAutoresizingMask: Bool? = nil) {
        for subview in subviews {
            self.addSubview(subview)
            if turnOffTranslatesAutoresizingMask == true {
                subview.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
}
