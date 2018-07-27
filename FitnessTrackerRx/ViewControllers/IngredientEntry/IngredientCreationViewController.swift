// 
//  IngredientCreationViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/22/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit
import ReactiveCocoa
import RxSwift

final internal class IngredientCreationViewController: UITableViewController {
    
    private let viewModel: IngredientCreationViewModelType = IngredientCreationViewModel()
    let disposeBag = DisposeBag()
    
    enum CellModel {
        case nameEntry
        case proteinEntry
        case carbsEntry
        case fatEntry
        case done
    }
    
    internal init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dataProvider = TableDataProvider<CellModel>(
        sections: [.init([.nameEntry, .proteinEntry, .carbsEntry, .fatEntry]), .init([.done])],
        cellCreationBlock: { [unowned self] tableView, model, indexPath in
            func textEntryCell(leftText: String, keyboardType: UIKeyboardType, action: @escaping (String) -> Void) -> TextEntryCell {
                let cell = TextEntryCell()
                cell.selectionStyle = .none
                cell.leftLabel.text = leftText
                cell.textField.keyboardType = keyboardType
                cell.textField.reactive    
                    .continuousTextValues
                    .map { $0 ?? "" }
                    .observeValues(action)
                return cell
            }
            
            switch model {
            case .nameEntry:
                return textEntryCell(leftText: "Name:", keyboardType: .default, action: self.viewModel.inputs.setName)
            case .proteinEntry:
                return textEntryCell(leftText: "Protein:", keyboardType: .decimalPad, action: { string in
                    self.viewModel.inputs.setProteinGrams(Int(string))
                })
            case .carbsEntry:
                return textEntryCell(leftText: "Carbs:", keyboardType: .decimalPad, action: { string in
                    self.viewModel.inputs.setCarbsGrams(Int(string))
                })
            case .fatEntry:
                return textEntryCell(leftText: "Fat:", keyboardType: .decimalPad, action: { string in
                    self.viewModel.inputs.setFatGrams(Int(string))
                })
            case .done:
                let cell = DoneButtonCell()
                cell.doneButton.isEnabled = false
                cell.selectionStyle = .none
                self.viewModel.outputs.doneButtonEnabled
                    .observeOnUI()
                    .subscribe(onNext: { isEnabled in
                        cell.doneButton.isEnabled = isEnabled
                    })
                    .disposed(by: self.disposeBag)
                
                cell.doneButton.reactive
                    .controlEvents(.touchUpInside)
                    .observeValues { _ in
                        self.viewModel.inputs.donePressed()
                    }
                return cell
            }
        },
        didSelectBlock: { tableView, dataProvider, model, indexPath in
            switch model {
            case .done:
                (tableView.cellForRow(at: indexPath) as! DoneButtonCell).doneButton.sendActions(for: .touchUpInside)
            default:
                let cell = tableView.cellForRow(at: indexPath) as! TextEntryCell
                cell.textField.becomeFirstResponder()
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Ingredient"
        self.tableView.set(dataProvider: self.dataProvider)
        
        self.viewModel.outputs.dismiss
            .observeOnUI()
            .subscribe(onNext: { _ in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
}
