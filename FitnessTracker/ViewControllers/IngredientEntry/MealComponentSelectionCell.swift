//
//  MealComponentSelectionCell.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit

internal final class MealComponentSelectionCell: UITableViewCell, View {
    
    func configure(with viewModel: Meal.Component) {
        self.textLabel?.text = viewModel.name
    }
}
