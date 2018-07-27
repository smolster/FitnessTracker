//
//  UITableViewController+Extension.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/26/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

extension UITableView {
    public func deselectSelectedRows(animated: Bool) {
        self.indexPathsForSelectedRows?.forEach { self.deselectRow(at: $0, animated: animated) }
    }
}
