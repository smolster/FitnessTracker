//
//  MealComponentCell.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit

internal final class MealComponentCell: UITableViewCell, View {
    typealias ViewModel = Meal.ComponentAndAmount
    
    private let leftLabel = UILabel.base()
    private let rightLabel = UILabel.base()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.addSubviews([leftLabel, rightLabel])
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding(.large)),
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding(.large)),
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding(.large)),
            
            rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding(.large)),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding(.large)),
            rightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding(.large)),
            
            leftLabel.trailingAnchor.constraint(equalTo: rightLabel.leadingAnchor, constant: -padding(.large))
        ])
        
        leftLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        rightLabel.textAlignment = .right
    }
    
    internal func configure(with viewModel: Meal.ComponentAndAmount) {
        let leftText: String
        switch viewModel.component {
        case .recipe(let recipe):           leftText = "\(recipe.name) (R)"
        case .ingredient(let ingredient):   leftText = "\(ingredient.name) (I)"
        }
        self.leftLabel.text = leftText
        
        self.rightLabel.text = "Calories: \(viewModel.component.calories(in: viewModel.amount))"
    }
}
