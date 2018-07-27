//
//  CollectionDataProvider+Inits.swift
//  FitnessTrackerKit
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit

public extension CollectionDataProvider {
    
    // MARK: - Table Inits
    
    public static func table(
        sections: [Section],
        cellCreationBlock: @escaping TableCellCreationBlock,
        prefetchBlock: TablePrefetchBlock? = nil,
        cancelPrefetchBlock: TablePrefetchBlock? = nil,
        didSelectBlock: TableSelectBlock? = nil,
        didDeselectBlock: TableSelectBlock? = nil
    ) -> CollectionDataProvider<Model> {
        return .init(
            sections: sections,
            cellCreationBlock: cellCreationBlock,
            prefetchBlock: prefetchBlock,
            cancelPrefetchBlock: cancelPrefetchBlock,
            didSelectBlock: didSelectBlock,
            didDeselectBlock: didDeselectBlock
        )
    }
    
    public static func table(
        models: [Model],
        cellCreationBlock: @escaping TableCellCreationBlock,
        prefetchBlock: TablePrefetchBlock? = nil,
        cancelPrefetchBlock: TablePrefetchBlock? = nil,
        didSelectBlock: TableSelectBlock? = nil,
        didDeselectBlock: TableSelectBlock? = nil
    ) -> CollectionDataProvider<Model> {
        return .init(
            sections: [Section(models)],
            cellCreationBlock: cellCreationBlock,
            prefetchBlock: prefetchBlock,
            cancelPrefetchBlock: cancelPrefetchBlock,
            didSelectBlock: didSelectBlock,
            didDeselectBlock: didDeselectBlock
        )
    }
    
    public static func table<Cell: UITableViewCell>(
        models: [Model],
        cellType: Cell.Type,
        prefetchBlock: TablePrefetchBlock? = nil,
        cancelPrefetchBlock: TablePrefetchBlock? = nil,
        didSelectBlock: TableSelectBlock? = nil,
        didDeselectBlock: TableSelectBlock? = nil
    ) -> CollectionDataProvider<Model> where Cell: View, Cell.ViewModel == Model {
        return .table(
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
    
    // MARK: - Collection Inits
    
    public static func collection(
        sections: [Section],
        cellCreationBlock: @escaping CollectionCellCreationBlock,
        prefetchBlock: CollectionPrefetchBlock? = nil,
        cancelPrefetchBlock: CollectionPrefetchBlock? = nil,
        didSelectBlock: CollectionSelectBlock? = nil,
        didDeselectBlock: CollectionSelectBlock? = nil
    ) -> CollectionDataProvider<Model> {
        return .init(
            sections: sections,
            cellCreationBlock: cellCreationBlock,
            prefetchBlock: prefetchBlock,
            cancelPrefetchBlock: cancelPrefetchBlock,
            didSelectBlock: didSelectBlock,
            didDeselectBlock: didDeselectBlock
        )
    }
    
    public static func collection(
        models: [Model],
        cellCreationBlock: @escaping CollectionCellCreationBlock,
        prefetchBlock: CollectionPrefetchBlock? = nil,
        cancelPrefetchBlock: CollectionPrefetchBlock? = nil,
        didSelectBlock: CollectionSelectBlock? = nil,
        didDeselectBlock: CollectionSelectBlock? = nil
    ) -> CollectionDataProvider<Model> {
        return .collection(
            sections: [.init(models)],
            cellCreationBlock: cellCreationBlock,
            prefetchBlock: prefetchBlock,
            cancelPrefetchBlock: cancelPrefetchBlock,
            didSelectBlock: didSelectBlock,
            didDeselectBlock: didDeselectBlock
        )
    }
}
