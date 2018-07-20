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

public extension CollectionDataProvider where Model: CollectionCellTypesProviding {
    
    public convenience init(
        for collectionView: UICollectionView,
        models: [Model],
        cellCreationBlock: @escaping CellCreationBlock,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil
    ) {
        self.init(
            models: models,
            cellCreationBlock: cellCreationBlock,
            prefetchBlock: prefetchBlock,
            cancelPrefetchBlock: cancelPrefetchBlock
        )
        collectionView.register(Model.cellTypes)
    }
    
    public convenience init(
        for collectionView: UICollectionView,
        sections: [Section],
        cellCreationBlock: @escaping CellCreationBlock,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil
    ) {
        self.init(
            sections: sections,
            cellCreationBlock: cellCreationBlock,
            prefetchBlock: prefetchBlock,
            cancelPrefetchBlock: cancelPrefetchBlock
        )
        collectionView.register(Model.cellTypes)
    }
    
}
