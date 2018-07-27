//
//  TextEntryCell.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public final class TextEntryCell: UITableViewCell {
    
    public let leftLabel = UILabel.base()
    public let textField = UITextField()
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.addSubviews([leftLabel, textField], turnOffTranslatesAutoresizingMask: true)
        NSLayoutConstraint.activate([
            // Left Label <-> Content View
            leftLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding(.large)),
            leftLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding(.large)),
            leftLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding(.large)),
            
            // Text Field <-> Content View
            textField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding(.large)),
            textField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding(.large)),
            textField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding(.large)),
            
            // Text Field <-> Left Label
            leftLabel.trailingAnchor.constraint(equalTo: self.textField.leadingAnchor, constant: -padding(.large))
        ])
        leftLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        leftLabel.font = .preferredFont(forTextStyle: .body)
        textField.font = .preferredFont(forTextStyle: .body)
        textField.borderStyle = .none
    }
    
}
