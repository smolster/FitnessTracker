//
//  CellTypesProviding.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/8/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import UIKit

public protocol CollectionCellTypesProviding {
    static var cellTypes: [UICollectionViewCell.Type] { get }
}

public protocol TableCellTypesProviding {
    static var cellTypes: [UITableViewCell.Type] { get }
}
