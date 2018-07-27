//
//  TextEntryCell.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit

extension UIView {
    func addSubviews(_ subviews: [UIView], turnOffTranslatesAutoresizingMask: Bool? = nil) {
        for subview in subviews {
            self.addSubview(subview)
            if turnOffTranslatesAutoresizingMask == true {
                subview.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
}

final internal class TextEntryCell: UITableViewCell {

    internal let leftLabel = UILabel()
    internal let textField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
