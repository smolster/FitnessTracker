//
//  Padding.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/20/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public enum Padding {
    
    /// 0
    case none
    
    /// 5
    case small
    
    /// 10
    case medium
    
    /// 15
    case large
    
    /// 20
    case extraLarge
    
    fileprivate var value: CGFloat {
        switch self {
        case .none:         return 0.0
        case .small:        return 5.0
        case .medium:       return 10.0
        case .large:        return 15.0
        case .extraLarge:   return 20.0
        }
    }
}

public func padding(_ style: Padding) -> CGFloat {
    return style.value
}

public func translatesOff(for views: [UIView]) {
    views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
}
