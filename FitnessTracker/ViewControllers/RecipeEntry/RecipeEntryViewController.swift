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
    
    enum CellModel: TableCellTypesProviding {
        case nameEntry
        case ingredient(Ingredient)
        case addIngredient
        
        static var cellTypes: [UITableViewCell.Type] {
            return [UITableViewCell.self]
        }
    }
    
    private var dataProvider: TableDataProvider<CellModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellModel.cellTypes)
        
        self.dataProvider = TableDataProvider<CellModel>(
            for: <#T##UITableView#>,
            models: <#T##[RecipeEntryViewController.CellModel]#>,
            cellCreationBlock: <#T##(UITableView, RecipeEntryViewController.CellModel, IndexPath) -> UITableViewCell#>
        )
        
        (
            for: self.tableView,
            models: <#T##[RecipeEntryViewController.CellModel]#>,
            cellType: <#T##View.Protocol#>)
    }
    
}
