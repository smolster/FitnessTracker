//
//  TodayViewController.swift
//  FitnessTrackerReSwift
//
//  Created by Swain Molster on 7/27/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import ReSwift
import FitnessTrackerKit

internal final class TodayViewController: UIViewController {
    
    private enum CellModel {
        case totalCalories(Calories)
        case totalMacros(MacroCount)
        
        case meal(Meal, displayTime: String)
        
        case addMeal
    }
    
    private lazy var dataProvider: CollectionDataProvider<CellModel> = .table(
        sections: [],
        cellCreationBlock: { tableView, model, indexPath in
            switch model {
            case .totalCalories(let cals):
                let cell = TwoLabelCell()
                cell.leftText = "Calories:"
                cell.rightText = "\(cals.rawValue)"
                return cell
            case .totalMacros(let macros):
                let cell = TwoLabelCell()
                cell.leftText = "Macros:"
                cell.rightText =
                """
                Protein: \(macros.protein.rawValue)g
                Carbs: \(macros.carbs.rawValue)g
                Fat: \(macros.fat.rawValue)g
                """
                return cell
            case .meal(let meal, let displayTime):
                let cell = TwoLabelCell()
                cell.leftText = displayTime
                return cell
            case .addMeal:
                let cell = DoneButtonCell()
                cell.title = "Add Meal"
                cell.doneButton.rx
                    .controlEvent(.touchUpInside)
                    .bind(onNext: self.viewModel.inputs.addEntryPressed)
                    .disposed(by: self.disposeBag)
                return cell
            }
            
        },
        didSelectBlock: { [unowned self] tableView, dataProvider, model, indexPath in
            switch model {
            case .meal(let meal, _):
                self.viewModel.inputs.selectedMeal(meal)
            default:
                return
            }
        }
    )
}
