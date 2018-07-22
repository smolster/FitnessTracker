// 
//  IngredientSelectionViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit
import ReactiveCocoa
import ReactiveSwift
import Result

final internal class IngredientSelectionViewController: UITableViewController {
    
    private let viewModel: IngredientSelectionViewModelType = IngredientSelectionViewModel()
    
    enum CellModel {
        case item(Ingredient)
        case createNew
    }
    
    private let chosenBlock: (Ingredient) -> Void
    
    internal init(_ chosenBlock: @escaping (Ingredient) -> Void) {
        self.chosenBlock = chosenBlock
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dataProvider = TableDataProvider<CellModel>(
        sections: [],
        cellCreationBlock: { tableView, model, indexPath in
            switch model {
            case .item(let ingredient):
                let cell = tableView.dequeueReusableCell(withType: IngredientCell.self, for: indexPath)
                cell.configure(with: ingredient)
                return cell
            case .createNew:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Create new ingredient..."
                return cell
            }
        },
        didSelectBlock: { [unowned self] tableView, dataProvider, model, indexPath in
            switch model {
            case .item(let ingredient):
                self.viewModel.inputs.ingredientSelected(ingredient)
                self.chosenBlock(ingredient)
            case .createNew:
                self.viewModel.inputs.createNewPressed()
            }
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register([IngredientCell.self])
        self.tableView.set(dataProvider: self.dataProvider)
        
        self.viewModel.outputs.ingredients
            .observe(on: UIScheduler())
            .observeValues { ingredients in
                self.dataProvider.sections = ingredients
                .isEmpty ?
                    [.init([.createNew])] :
                    [.init(ingredients.map {  CellModel.item($0) }), .init([.createNew])]
                self.tableView.reloadData()
            }
        
        self.viewModel.outputs.goToCreateNew
            .observe(on: UIScheduler())
            .observeValues {
                self.present(IngredientCreationViewController(), animated: true, completion: nil)
            }
        
        self.viewModel.outputs.dismissIfPresented
            .observe(on: UIScheduler())
            .observeValues {
                if self.isBeingPresented {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputs.viewWillAppear()
    }
    
}
