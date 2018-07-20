//
//  TableLayoutFlowDelegate.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/8/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import UIKit

public class TableLayoutFlowDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: UICollectionViewFlowLayoutAutomaticSize.height)
    }
}

extension UICollectionViewDelegateFlowLayout {
    static var table: UICollectionViewDelegateFlowLayout {
        return TableLayoutFlowDelegate()
    }
}
