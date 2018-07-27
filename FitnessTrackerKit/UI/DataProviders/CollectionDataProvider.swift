//
//  TableDataProvider.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/12/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import Foundation
import UIKit

public class CollectionDataProvider<Model>: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegate {
    
    public typealias TableCellCreationBlock = (UITableView, Model, IndexPath) -> UITableViewCell
    public typealias TablePrefetchBlock = (UITableView, [Model]) -> Void
    public typealias TableSelectBlock = (UITableView, CollectionDataProvider<Model>, Model, IndexPath) -> Void
    
    public typealias CollectionCellCreationBlock = (UICollectionView, Model, IndexPath) -> UICollectionViewCell
    public typealias CollectionPrefetchBlock = (UICollectionView, [Model]) -> Void
    public typealias CollectionSelectBlock = (UICollectionView, CollectionDataProvider<Model>, Model, IndexPath) -> Void
    
    public struct Section {
        var models: [Model]
        public let headerString: String?
        public let footerString: String?
        
        public init(_ models: [Model], headerString: String? = nil, footerString: String? = nil) {
            self.models = models
            self.headerString = headerString
            self.footerString = footerString
        }
    }
    
    public var sections: [Section]
    
    private let tableCellCreationBlock: TableCellCreationBlock?
    private let tablePrefetchBlock: TablePrefetchBlock?
    private let tableCancelPrefetchBlock: TablePrefetchBlock?
    private let tableDidSelectBlock: TableSelectBlock?
    private let tableDidDeselectBlock: TableSelectBlock?
    
    private let collectionCellCreationBlock: CollectionCellCreationBlock?
    private let collectionPrefetchBlock: CollectionPrefetchBlock?
    private let collectionCancelPrefetchBlock: CollectionPrefetchBlock?
    private let collectionDidSelectBlock: CollectionSelectBlock?
    private let collectionDidDeselectBlock: CollectionSelectBlock?
    
    internal init(
        sections: [Section],
        cellCreationBlock: @escaping TableCellCreationBlock,
        prefetchBlock: TablePrefetchBlock? = nil,
        cancelPrefetchBlock: TablePrefetchBlock? = nil,
        didSelectBlock: TableSelectBlock? = nil,
        didDeselectBlock: TableSelectBlock? = nil
    ) {
        self.sections = sections
        self.tableCellCreationBlock = cellCreationBlock
        self.tablePrefetchBlock = prefetchBlock
        self.tableCancelPrefetchBlock = cancelPrefetchBlock
        self.tableDidSelectBlock = didSelectBlock
        self.tableDidDeselectBlock = didDeselectBlock
        
        self.collectionCellCreationBlock = nil
        self.collectionPrefetchBlock = nil
        self.collectionCancelPrefetchBlock = nil
        self.collectionDidSelectBlock = nil
        self.collectionDidDeselectBlock = nil
        super.init()
    }
    
    internal init(
        sections: [Section],
        cellCreationBlock: @escaping CollectionCellCreationBlock,
        prefetchBlock: CollectionPrefetchBlock? = nil,
        cancelPrefetchBlock: CollectionPrefetchBlock? = nil,
        didSelectBlock: CollectionSelectBlock? = nil,
        didDeselectBlock: CollectionSelectBlock? = nil
    ) {
        self.sections = sections
        self.collectionCellCreationBlock = cellCreationBlock
        self.collectionPrefetchBlock = prefetchBlock
        self.collectionCancelPrefetchBlock = cancelPrefetchBlock
        self.collectionDidSelectBlock = didSelectBlock
        self.collectionDidDeselectBlock = didDeselectBlock
        
        self.tableCellCreationBlock = nil
        self.tablePrefetchBlock = nil
        self.tableCancelPrefetchBlock = nil
        self.tableDidSelectBlock = nil
        self.tableDidDeselectBlock = nil
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if sections.isEmpty { return 0 }
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCellCreationBlock!(tableView, sections[indexPath.section].models[indexPath.row], indexPath)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].headerString
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.sections[section].footerString
    }
    
    private func models(withIndexPaths indexPaths: [IndexPath]) -> [Model] {
        return indexPaths.map({ sections[$0.section].models[$0.item] })
    }
    
    // MARK: - UITableViewDataSourcePrefetching
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        self.tablePrefetchBlock?(tableView, models(withIndexPaths: indexPaths))
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        self.tableCancelPrefetchBlock?(tableView, models(withIndexPaths: indexPaths))
    }
    
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableDidSelectBlock?(tableView, self, sections[indexPath.section].models[indexPath.row], indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tableDidDeselectBlock?(tableView, self, sections[indexPath.section].models[indexPath.row], indexPath)
    }
    
    // MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.collectionCellCreationBlock!(collectionView, sections[indexPath.section].models[indexPath.item], indexPath)
    }
    
    // MARK: - UICollectionViewDataSourcePrefetching
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        self.collectionPrefetchBlock?(collectionView, models(withIndexPaths: indexPaths))
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        self.collectionCancelPrefetchBlock?(collectionView, models(withIndexPaths: indexPaths))
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionDidSelectBlock?(collectionView, self, sections[indexPath.section].models[indexPath.item], indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.collectionDidDeselectBlock?(collectionView, self, sections[indexPath.section].models[indexPath.item], indexPath)
    }
    
}

public extension CollectionDataProvider {
    
    public func insert(sections: [(section: Section, index: Int)], on tableView: UITableView, with animation: UITableViewRowAnimation = .automatic) {
        let descendingSections = sections.sorted(by: { $0.index > $1.index })
        
        let indexSet = descendingSections.reduce(into: IndexSet()) { result, entry in
            result.insert(entry.index)
            
            // While we're at it, we can insert into the models.
            self.sections.insert(entry.section, at: entry.index)
        }
        
        tableView.insertSections(indexSet, with: animation)
    }
    
    public func insert(models: [(model: Model, indexPath: IndexPath)], on tableView: UITableView, with animation: UITableViewRowAnimation = .automatic) {
        let descendingEntries = models.sorted(by: { lhs, rhs in
            if lhs.indexPath.section == rhs.indexPath.section {
                return lhs.indexPath.row > rhs.indexPath.row
            }
            return lhs.indexPath.section > rhs.indexPath.section
        })
        
        let indexPaths = descendingEntries.reduce(into: [IndexPath]()) { result, modelAndIndexPath in
            result.append(modelAndIndexPath.indexPath)
            
            // While we're at it, we can insert into the models
            self.sections[modelAndIndexPath.indexPath.section].models.insert(modelAndIndexPath.model, at: modelAndIndexPath.indexPath.row)
        }
        
        tableView.insertRows(at: indexPaths, with: animation)
    }
}

public extension UITableView {
    /**
     Sets a `dataProvider` as the receiver's `dataSource` and `delegate`.
     
     - parameter dataProvider: The `TableDataProvider` to use.
     */
    public func set<T>(dataProvider: CollectionDataProvider<T>) {
        self.dataSource = dataProvider
        self.delegate = dataProvider
    }
}

public extension UICollectionView {
    /**
     Sets a `dataProvider` as the receiver's `dataSource` and `delegate`.
     
     - parameter dataProvider: The `TableDataProvider` to use.
     */
    public func set<T>(dataProvider: CollectionDataProvider<T>) {
        self.dataSource = dataProvider
        self.delegate = dataProvider
    }
}
