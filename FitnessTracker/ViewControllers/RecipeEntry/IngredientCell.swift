//
//  IngredientCell.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit

class IngredientCell: UITableViewCell, View {
    
    func configure(with viewModel: Ingredient) {
        self.textLabel?.text = viewModel.name
    }
    
}
