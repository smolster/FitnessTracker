//
//  TwoLabelCell.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit

internal final class TwoLabelCell: UITableViewCell {
    private let leftLabel = UILabel.base()
    private let rightLabel = UILabel.base()
    
    internal var leftText: String {
        get {
            return leftLabel.text ?? ""
        }
        set {
            self.leftLabel.text = newValue
        }
    }
    
    internal var rightText: String {
        get {
            return rightLabel.text ?? ""
        }
        set {
            self.rightLabel.text = newValue
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        leftLabel.numberOfLines = 0
        rightLabel.numberOfLines = 0
        
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
}
