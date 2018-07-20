//
//  CollectionDataProvider.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/8/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import UIKit

public class CollectionDataProvider<Model>: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    public typealias CellCreationBlock = (UICollectionView, Model, IndexPath) -> UICollectionViewCell
    public typealias PrefetchBlock = (UICollectionView, [Model]) -> Void
    
    public struct Section {
        let headerString: String? = nil
        var models: [Model]
        let footerString: String? = nil
    }
    
    fileprivate(set) var sections: [Section]
    fileprivate let cellCreationBlock: CellCreationBlock
    
    fileprivate let prefetchBlock: PrefetchBlock?
    fileprivate let cancelPrefetchBlock: PrefetchBlock?
    
    public convenience init<Cell: UICollectionViewCell>(
        models: [Model],
        cellType: Cell.Type,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil
    ) where Cell: View, Cell.ViewModel == Model {
        self.init(
            models: models,
            cellCreationBlock: { collectionView, model, indexPath in
                let cell = collectionView.dequeueReusableCell(withType: cellType, for: indexPath)
                cell.configure(with: model)
                return cell
            }
        )
    }
    
    public init(
        models: [Model],
        cellCreationBlock: @escaping CellCreationBlock,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil
    ) {
        self.sections = [Section(models: models)]
        self.cellCreationBlock = cellCreationBlock
        self.prefetchBlock = prefetchBlock
        self.cancelPrefetchBlock = cancelPrefetchBlock
    }
    
    public init(
        sections: [Section],
        cellCreationBlock: @escaping CellCreationBlock,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil
    ) {
        self.sections = sections
        self.cellCreationBlock = cellCreationBlock
        self.prefetchBlock = prefetchBlock
        self.cancelPrefetchBlock = cancelPrefetchBlock
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellCreationBlock(collectionView, sections[indexPath.section].models[indexPath.item], indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefetchBlock?(collectionView, models(forIndexPaths: indexPaths))
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancelPrefetchBlock?(collectionView, models(forIndexPaths: indexPaths))
    }
    
    fileprivate func models(forIndexPaths indexPaths: [IndexPath]) -> [Model] {
        return indexPaths.map({ sections[$0.section].models[$0.item] })
    }
    
}
