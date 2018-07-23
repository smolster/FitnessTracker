1// 
//  RecipeCreationViewController.swift
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

final internal class RecipeCreationViewController: UITableViewController {
    
    private let viewModel: RecipeCreationViewModelType = RecipeCreationViewModel()
    
    internal init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum CellModel {
        case nameEntry
        case ingredient(Ingredient)
        case addIngredient
        case done
        
        var selectable: Bool {
            switch self {
            case .nameEntry, .ingredient: return false
            case .addIngredient, .done: return true
            }
        }
    }
    
    private lazy var dataProvider = TableDataProvider<CellModel>(
        sections: [.init([.nameEntry, .addIngredient]), .init([.done])],
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
                return cell
            case .addIngredient:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Add Ingredient..."
                return cell
            case .done:
                let cell = DoneButtonCell()
                cell.doneButton.reactive.isEnabled <~ self.viewModel.outputs.doneButtonEnabled
                cell.doneButton.reactive.touchUpControlEvent.observeValues { _ in
                    self.viewModel.inputs.donePressed()
                }
                return cell
            }
        },
        didSelectBlock: { [unowned self] tableView, dataProvider, cellModel, indexPath in
            switch cellModel {
            case .nameEntry:
                (tableView.cellForRow(at: indexPath) as? TextEntryCell)?.textField.becomeFirstResponder()
            case .ingredient:
                return
            case .addIngredient:
                self.navigationController?.pushViewController(MealComponentSelectionViewController(kind: .ingredient, { component in
                    guard case .ingredient(let ingredient) = component else {
                        fatalError()
                    }
                    dataProvider.insert(models: [(.ingredient(ingredient), IndexPath(row: 1, section: 0))], on: tableView)
                    self.viewModel.inputs.ingredientSelected(ingredient)
                }), animated: true)
            case .done:
                (tableView.cellForRow(at: indexPath) as? DoneButtonCell)?.doneButton.sendActions(for: .touchUpInside)
            }
            
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Recipe"
        tableView.allowsMultipleSelection = false
        tableView.set(dataProvider: dataProvider)
        
        self.viewModel.outputs.showAlertToGatherAmountOfIngredient
            .observeOnUI()
            .observeValues { ingredient in
                let alert = UIAlertController.textEntry(
                    message: "How many grams of \(ingredient.name)",
                    keyboardType: .decimalPad,
                    textIsValid: { Int($0) != nil },
                    doneActionBlock: { alertController, string in
                        self.viewModel.inputs.amountSelected(for: ingredient, amount: .init(rawValue: Int(string)!))
                        alertController.dismiss(animated: true, completion: nil)
                    }
                )
                self.present(alert, animated: true, completion: nil)
            }
        
        self.viewModel.outputs.showConfirmationAndDismiss
            .observeOnUI()
            .observeValues {
                self.dismissOrPop()
            }
    }
    
}
