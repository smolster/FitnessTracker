//
//  UILabel+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public extension UILabel {
    public static func base(using textStyle: UIFontTextStyle = .body, compatibleWith traitCollection: UITraitCollection? = nil) -> UILabel {
        let label = self.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
        return label
    }
}
