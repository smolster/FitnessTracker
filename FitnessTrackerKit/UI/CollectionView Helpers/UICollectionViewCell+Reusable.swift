//
//  UICollectionViewCell+Reusable.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/8/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import UIKit

public extension UICollectionViewCell {
    
    /**
     Dequeues an instance of the cell from `collectionView`.
     
     - parameter collectionView: The `UICollectionView` to register and dequeue with
     */
    public class func create(on collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        if collectionView.registeredCellIdentifiers.contains(self.reuseIdentifier) == false {
            collectionView.register([self])
        }
        return collectionView.dequeueReusableCell(withType: self, for: indexPath)
    }
}
