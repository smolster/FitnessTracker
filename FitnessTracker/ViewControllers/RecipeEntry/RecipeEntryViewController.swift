// 
//  RecipeEntryViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit

final internal class RecipeEntryViewController: UITableViewController {
    
    private let viewModel: RecipeEntryViewModelType = RecipeEntryViewModel()
    
    internal init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum CellModel: TableCellTypesProviding {
        case nameEntry
        case ingredient(Ingredient)
        case addIngredient
        
        static var cellTypes: [UITableViewCell.Type] {
            return [IngredientCell.self]
        }
        
        var selectable: Bool {
            switch self {
            case .nameEntry: return false
            case .ingredient: return false
            case .addIngredient: return true
            }
        }
    }
    
    private lazy var dataProvider = TableDataProvider<CellModel>(
        models: [.nameEntry, .addIngredient],
        cellCreationBlock: { [unowned self] tableView, cellModel, indexPath in
            switch cellModel {
            case .nameEntry:
                let cell = TextEntryCell()
                cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
                cell.selectionStyle = .none
                cell.leftLabel.text = "Name"
                cell.textField.reactive
                    .continuousTextValues
                    .mapNilToEmpty
                    .observeValues(self.viewModel.inputs.nameUpdated(to:))
                return cell
            case .ingredient(let ingredient):
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = ingredient.name
                cell.accessoryType = .disclosureIndicator
                return cell
            case .addIngredient:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Add Ingredient..."
                return cell
            }
        },
        didSelectBlock: { [unowned self] _, dataProvider, cellModel, indexPath in
            switch cellModel {
            case .addIngredient:
                return
//                dataProvider.insert(
//                    [(.ingredient(.init(name: "Test")), IndexPath(row: indexPath.row, section: indexPath.section))],
//                    on: tableView,
//                    with: .automatic
//                )
            default: return
            }
            
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellModel.cellTypes)
        tableView.set(dataProvider: dataProvider)
    }
    
}

extension UITableView {
    func set<T>(dataProvider: TableDataProvider<T>) {
        self.dataSource = dataProvider
        self.delegate = dataProvider
    }
}
