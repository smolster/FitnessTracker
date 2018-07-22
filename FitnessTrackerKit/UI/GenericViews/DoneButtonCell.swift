//
//  DoneButtonCell.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public final class DoneButtonCell: UITableViewCell {
    public let doneButton = UIButton(type: .custom)
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.doneButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(doneButton)
        
        self.doneButton.setTitle("Done", for: UIControlState())
        self.doneButton.setTitleColor(.blue, for: UIControlState())
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding(.large)),
            doneButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding(.medium)),
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding(.medium)),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding(.large))
        ])
        
        self.doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
    }
    
    @objc private func donePressed() {
        self.setSelected(true, animated: false)
    }
    
}
