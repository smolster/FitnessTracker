//
//  SingleSelectionViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import Foundation
import UIKit

final public class SingleSelectionViewController<Model>: UITableViewController {
    
    public typealias DidSelectBlock = (_ model: Model, _ on: SingleSelectionViewController<Model>) -> Void
    public typealias CellConfigurationBlock = (_ cell: UITableViewCell, _ model: Model) -> Void
    
    private let models: [Model]
    private let didSelect: DidSelectBlock
    private let configureCell: CellConfigurationBlock
    private var currentSelectedIndex: Int?
    
    private lazy var dataProvider = TableDataProvider<Model>(
        models: self.models,
        cellCreationBlock: { [unowned self] tableView, model, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            self.configureCell(cell, model)
            if let selected = self.currentSelectedIndex {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        },
        didSelectBlock: { [unowned self] tableView, _, model, indexPath in
            if let alreadySelectedIndex = self.currentSelectedIndex {
                tableView.deselectRow(at: IndexPath(row: alreadySelectedIndex, section: 0), animated: false)
            }
            self.currentSelectedIndex = indexPath.row
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.didSelect(model, self)
        },
        didDeselectBlock: { [unowned self] tableView, _, model, indexPath in
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
    )
    
    public init(
        models: [Model],
        alreadySelectedIndex: Int? = nil,
        configureCell: @escaping CellConfigurationBlock,
        didSelect: @escaping DidSelectBlock
    ) {
        self.models = models
        self.currentSelectedIndex = alreadySelectedIndex
        self.didSelect = didSelect
        self.configureCell = configureCell
        super.init(style: .plain)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.allowsMultipleSelection = false
        self.tableView.set(dataProvider: self.dataProvider)
    }
    
}
