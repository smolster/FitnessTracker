//
//  UITableViewCell+Reusable.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/8/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    
    /**
     Dequeues an instance of the cell from `collectionView`.
     
     - parameter tableView: The `UITableView` to register and dequeue with
     */
    public class func create(on tableView: UITableView, at indexPath: IndexPath) -> Self {
        if tableView.registeredCellIdentifiers.contains(self.reuseIdentifier) == false {
            tableView.register([self])
        }
        return tableView.dequeueReusableCell(withType: self, for: indexPath)
    }
}
