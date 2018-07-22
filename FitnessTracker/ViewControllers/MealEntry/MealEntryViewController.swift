//
//  MealEntryViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/21/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit
import ReactiveSwift
import ReactiveCocoa
import Result

class MealEntryViewController: UITableViewController {
    
    enum CellModel: TableCellTypesProviding {
        case item(Meal.ComponentAndAmount)
        case addItem
        case done
        
        static var cellTypes: [UITableViewCell.Type] {
            return [MealComponentCell.self]
        }
    }
    
    internal init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let viewModel: MealEntryViewModelType = MealEntryViewModel()
    
    private lazy var dataProvider = TableDataProvider<CellModel>(
        sections: [.init([.addItem]), .init([.done])],
        cellCreationBlock: { tableView, model, indexPath in
            switch model {
            case .item(let componentAndAmount):
                let cell = tableView.dequeueReusableCell(withType: MealComponentCell.self, for: indexPath)
                cell.configure(with: componentAndAmount)
                cell.selectionStyle = .none
                return cell
            case .addItem:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Add Item..."
                return cell
            case .done:
                let cell = DoneButtonCell()
                cell.doneButton.reactive
                    .touchUpControlEvent
                    .observeValues { [unowned self] _ in
                        self.viewModel.inputs.donePressed()
                    }
                return cell
            }
        },
        didSelectBlock: { [unowned self] tableView, dataProvider, model, indexPath in
            switch model {
            case .addItem:
                let actionSheet = UIAlertController(title: nil, message: "Which kind of item would you like to add?", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Ingredient", style: .default, handler: { _ in
                    self.viewModel.inputs.addIngredientPressed()
                }))
                self.present(actionSheet, animated: true, completion: nil)
            case .done:
                (tableView.cellForRow(at: indexPath) as! DoneButtonCell).doneButton.sendActions(for: .touchUpInside)
            case .item(let item):
                return
            }
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meal Entry"
        self.tableView.register(CellModel.cellTypes)
        self.tableView.set(dataProvider: self.dataProvider)
        self.tableView.allowsMultipleSelection = false
        
        self.viewModel.outputs.goToIngredientSelection
            .observe(on: UIScheduler())
            .observeValues { [unowned self] in self.navigationController?.pushViewController(IngredientSelectionViewController(self.viewModel.inputs.ingredientChosen), animated: true)
            }
        
        self.viewModel.outputs.showAlertToGatherAmountForComponent
            .observeOnUI()
            .observeValues { ingredient in
                let alert = UIAlertController(title: nil, message: "How much of this ingredient?", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Done", style: .default, handler: { action in
                    self.viewModel.inputs.ingredientAmountProvided(
                        for: ingredient,
                        amount: .init(rawValue: Int(alert.textFields!.first!.text ?? "") ?? 0)
                    )
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(doneAction)
                alert.addTextField(configurationHandler: { textField in
                    textField.keyboardType = .decimalPad
                    textField.reactive
                        .continuousTextValues
                        .mapNilToEmpty
                        .mapToInt
                        .observeValues { integer in
                            doneAction.isEnabled = integer != nil
                        }
                })
                
                self.present(alert, animated: true, completion: nil)
            }
        
        self.viewModel.outputs.insertIngredient
            .observeOnUI()
            .observeValues { ingredientAndAmount in
                let item: Meal.ComponentAndAmount = (.ingredient(ingredientAndAmount.0), ingredientAndAmount.1)
                self.dataProvider.insert([(.item(item), IndexPath(row: 0, section: 0))], on: self.tableView)
            }
    }

}
