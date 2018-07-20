//
//  TableDataProvider.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 5/12/18.
//  Copyright © 2018 Daymaker, Inc. All rights reserved.
//

import Foundation
import UIKit

public class TableDataProvider<Model>: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    public typealias CellCreationBlock = (UITableView, Model, IndexPath) -> UITableViewCell
    public typealias PrefetchBlock = (UITableView, [Model]) -> Void
    
    private weak var tableView: UITableView!
    
    public struct Section {
        var models: [Model]
        let headerString: String?
        let footerString: String?
        
        public init(models: [Model], headerString: String? = nil, footerString: String? = nil) {
            self.models = models
            self.headerString = headerString
            self.footerString = footerString
        }
    }
    
    public var sections: [Section] {
        didSet {
            self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows ?? [], with: .automatic)
        }
    }
    fileprivate let cellCreationBlock: CellCreationBlock
    
    fileprivate let prefetchBlock: PrefetchBlock?
    fileprivate let cancelPrefetchBlock: PrefetchBlock?
    
    public convenience init<Cell: UITableViewCell>(
        tableView: UITableView,
        models: [Model],
        cellType: Cell.Type,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil
    ) where Cell: View, Cell.ViewModel == Model {
        self.init(
            for: tableView,
            models: models,
            cellCreationBlock: { tableView, model, indexPath in
                let cell = tableView.dequeueReusableCell(withType: cellType, for: indexPath)
                cell.configure(with: model)
                return cell
            }
        )
    }
    
    public convenience init(
        for tableView: UITableView,
        models: [Model],
        cellCreationBlock: @escaping CellCreationBlock,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil
    ) {
        self.init(
            for: tableView,
            sections: [Section(models: models)],
            cellCreationBlock: cellCreationBlock,
            prefetchBlock: prefetchBlock,
            cancelPrefetchBlock: cancelPrefetchBlock
        )
    }
    
    public init(
        for tableView: UITableView,
        sections: [Section],
        cellCreationBlock: @escaping CellCreationBlock,
        prefetchBlock: PrefetchBlock? = nil,
        cancelPrefetchBlock: PrefetchBlock? = nil
    ) {
        self.tableView = tableView
        self.sections = sections
        self.cellCreationBlock = cellCreationBlock
        self.prefetchBlock = prefetchBlock
        self.cancelPrefetchBlock = cancelPrefetchBlock
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView = tableView
        return cellCreationBlock(tableView, sections[indexPath.section].models[indexPath.row], indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        self.prefetchBlock?(tableView, models(withIndexPaths: indexPaths))
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        self.cancelPrefetchBlock?(tableView, models(withIndexPaths: indexPaths))
    }
    
    private func models(withIndexPaths indexPaths: [IndexPath]) -> [Model] {
        return indexPaths.map({ sections[$0.section].models[$0.item] })
    }
}
