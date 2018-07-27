//
//  UILabel+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public extension UILabel {
    
    /**
     Returns a `UILabel` configured with a `textStyle` and a `traitCollection`.
     
     The returned label will have `translatesAutoresizingMaskIntoConstraints` set to `false` and `numberOfLines` set to 0.
     
     - Parameters:
        - textStyle: The `UIFontTextStyle` to set on the button. Default is `.body`.
        - traitCollection: The `UITraitCollection` to use in creating the font. Default is `nil`.
    */
    public static func base(using textStyle: UIFontTextStyle = .body, compatibleWith traitCollection: UITraitCollection? = nil) -> UILabel {
        let label = self.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
        return label
    }
}
