//
//  TableDataProvider.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/12/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import Foundation
import UIKit

public class TableDataProvider<Model>: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate {
    
    public typealias CellCreationBlock = (UITableView, Model, IndexPath) -> UITableViewCell
    public typealias PrefetchBlock = (UITableView, [Model]) -> Void
    public typealias SelectBlock = (UITableView, TableDataProvider<Model>, Model, IndexPath) -> Void
    
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
    
    private let cellCreationBlock: CellCreationBlock
    private let prefetchBlock: PrefetchBlock?
    private let cancelPrefetchBlock: PrefetchBlock?
    private let didSelectBlock: SelectBlock?
    private let didDeselectBlock: SelectBlock?
    
    public convenience init<Cell: UITableViewCell>(
        models: [Model],
        cellType: Cell.Type,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil,
        didSelectBlock: SelectBlock? = nil,
        didDeselectBlock: SelectBlock? = nil
    ) where Cell: View, Cell.ViewModel == Model {
        self.init(
            models: models,
            cellCreationBlock: { tableView, model, indexPath in
                let cell = tableView.dequeueReusableCell(withType: cellType, for: indexPath)
                cell.configure(with: model)
                return cell
            },
            prefetchBlock: prefetchBlock,
            cancelPrefetchBlock: cancelPrefetchBlock,
            didSelectBlock: didSelectBlock,
            didDeselectBlock: didDeselectBlock
        )
    }
    
    public convenience init(
        models: [Model],
        cellCreationBlock: @escaping CellCreationBlock,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil,
        didSelectBlock: SelectBlock? = nil,
        didDeselectBlock: SelectBlock? = nil
    ) {
        self.init(
            sections: [Section(models)],
            cellCreationBlock: cellCreationBlock,
            prefetchBlock: prefetchBlock,
            cancelPrefetchBlock: cancelPrefetchBlock,
            didSelectBlock: didSelectBlock,
            didDeselectBlock: didDeselectBlock
        )
    }
    
    public init(
        sections: [Section],
        cellCreationBlock: @escaping CellCreationBlock,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil,
        didSelectBlock: SelectBlock? = nil,
        didDeselectBlock: SelectBlock? = nil
    ) {
        self.sections = sections
        self.cellCreationBlock = cellCreationBlock
        self.prefetchBlock = prefetchBlock
        self.cancelPrefetchBlock = cancelPrefetchBlock
        self.didSelectBlock = didSelectBlock
        self.didDeselectBlock = didDeselectBlock
        super.init()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if sections.isEmpty { return 0 }
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellCreationBlock(tableView, sections[indexPath.section].models[indexPath.row], indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        self.prefetchBlock?(tableView, models(withIndexPaths: indexPaths))
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        self.cancelPrefetchBlock?(tableView, models(withIndexPaths: indexPaths))
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
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectBlock?(tableView, self, sections[indexPath.section].models[indexPath.row], indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.didDeselectBlock?(tableView, self, sections[indexPath.section].models[indexPath.row], indexPath)
    }
}

public extension TableDataProvider {
    
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
    public func set<T>(dataProvider: TableDataProvider<T>) {
        self.dataSource = dataProvider
        self.delegate = dataProvider
    }
}
