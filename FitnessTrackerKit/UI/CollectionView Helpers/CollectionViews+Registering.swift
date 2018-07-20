//
//  CollectionViews+Registering.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/8/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import UIKit

public extension UICollectionView {
    /**
     Registers the nibs associated with provided `cellTypes` for reuse.
     
     - Note: This function relies on the cell having an associated XIB, and relies on that XIB having the same name as the cell itself. (e.g. TestCell must have corresponding TestCell.xib)
     
     - parameter cellTypes: The types to register
     */
    public func register(_ cellTypes: [UICollectionViewCell.Type]) {
        for type in cellTypes where self.registeredCellIdentifiers.contains(type.reuseIdentifier) == false {
            let nib = UINib(nibName: type.nibName, bundle: Bundle(for: type))
            self.setValue(self.registeredCellIdentifiers + [type.reuseIdentifier], forUndefinedKey: "registeredCellIdentifiers")
        }
    }
    
    /**
     Attempts to dequeue a cell of the type provided.
     
     - parameter type: The cell type to try to dequeue
     - parameter indexPath: The index path at which to add the cell
     */
    public func dequeueReusableCell<C: UICollectionViewCell>(withType type: C.Type, for indexPath: IndexPath) -> C {
        return self.dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! C
    }
    
    public var registeredCellIdentifiers: [String] {
        return self.value(forUndefinedKey: "registeredCellIdentifiers") as! [String]
    }
}

public extension UITableView {
    /**
     Registers the nibs associated with provided `cellTypes` for reuse.
     
     - Note: This function relies on the cell having an associated XIB, and relies on that XIB having the same name as the cell itself. (e.g. TestCell must have corresponding TestCell.xib)
     
     - parameter cellTypes: The types to register
     */
    public func register(_ cellTypes: [UITableViewCell.Type]) {
        for type in cellTypes where self.registeredCellIdentifiers.contains(type.reuseIdentifier) == false {
            let nib = UINib(nibName: type.nibName, bundle: Bundle(for: type))
            self.register(nib, forCellReuseIdentifier: type.reuseIdentifier)
            self.setValue(self.registeredCellIdentifiers + [type.reuseIdentifier], forUndefinedKey: "registeredCellIdentifiers")
        }
    }
    
    /**
     Attempts to dequeue a cell of the type provided.
     
     - parameter type: The cell type to try to dequeue
     - parameter indexPath: The index path at which to add the cell
     */
    public func dequeueReusableCell<C: UITableViewCell>(withType type: C.Type, for indexPath: IndexPath) -> C {
        return self.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! C
    }
    
    public var registeredCellIdentifiers: [String] {
        return self.value(forUndefinedKey: "registeredCellIdentifiers") as! [String]
    }
}
