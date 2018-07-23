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
        sections: [
            .init([.addItem]),
            .init([.done])
        ],
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
                actionSheet.addAction(UIAlertAction(title: "Recipe", style: .default, handler: { _ in
                    self.viewModel.inputs.addRecipePressed()
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
            .observeOnUI()
            .observeValues { [unowned self] in self.navigationController?.pushViewController(MealComponentSelectionViewController(kind: .ingredient, self.viewModel.inputs.componentChosen), animated: true)
            }
        
        self.viewModel.outputs.goToRecipeSelection
            .observeOnUI()
            .observeValues { [unowned self] in
                self.navigationController?.pushViewController(MealComponentSelectionViewController(kind: .recipe, self.viewModel.inputs.componentChosen), animated: true)
            }
        
        self.viewModel.outputs.showAlertToGatherAmountForComponent
            .observeOnUI()
            .observeValues { component in
                let alert = UIAlertController(title: nil, message: "How many grams of this item?", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Done", style: .default, handler: { action in
                    self.viewModel.inputs.componentAmountProvided(
                        for: component,
                        amount: .init(rawValue: Int(alert.textFields!.first!.text ?? "") ?? 0)
                    )
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(doneAction)
                alert.addTextField(configurationHandler: { textField in
                    textField.keyboardType = .decimalPad
                    textField.reactive
                        .continuousIntValues
                        .observeValues { integer in
                            doneAction.isEnabled = integer != nil
                        }
                })
                
                self.present(alert, animated: true, completion: nil)
            }
        
        self.viewModel.outputs.insertComponent
            .observeOnUI()
            .observeValues { componentAndAmount in
                let sectionIndex: Int
                switch componentAndAmount.component {
                case .ingredient: sectionIndex = 1
                case .recipe: sectionIndex = 0
                }
                if self.dataProvider.sections[sectionIndex].headerString != componentAndAmount.component.kind.headerString {
                    // Need to insert the whole section, always at 0
                    self.dataProvider.insert(
                        sections: [(
                            .init([.item(componentAndAmount)], headerString: componentAndAmount.component.kind.headerString),
                            0
                        )],
                        on: self.tableView
                    )
                } else {
                    self.dataProvider.insert(
                        models: [(
                            .item(componentAndAmount),
                            IndexPath(row: 0, section: sectionIndex)
                        )],
                        on: self.tableView
                    )
                }
            }
        
    }

}

fileprivate extension Meal.Component.Kind {
    fileprivate var headerString: String {
        switch self {
        case .ingredient: return "Ingredients"
        case .recipe: return "Recipes"
        }
    }
}
