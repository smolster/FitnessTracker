//
//  GlobalStyles.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public struct GlobalStyles {
    /// Applys global FitnessTracker styles to UI elements.
    public static func apply() {
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().isTranslucent = true
    }
}
