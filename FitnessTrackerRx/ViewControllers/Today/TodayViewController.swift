// 
//  TodayViewController.swift
//  FitnessTracker
//
//  Created by Swain Molster on 7/25/18.
//  Copyright © 2018 Swain Molster. All rights reserved.
//

import UIKit
import FitnessTrackerKit
import RxSwift
import RxCocoa

final internal class TodayViewController: UITableViewController {
    
    private let viewModel: TodayViewModelType = TodayViewModel()
    private let disposeBag = DisposeBag()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.inputs.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Today"
        self.tableView.allowsMultipleSelection = false
        
        self.tableView.set(dataProvider: self.dataProvider)
        
        self.viewModel.outputs.today
            .observeOnUI()
            .subscribe(onNext: { dayWithMealDisplayTimes in
                guard let (day, mealsWithDisplayTimes) = dayWithMealDisplayTimes else {
                    self.dataProvider.sections = [.init([.addMeal])]
                    return
                }
                
                self.dataProvider.sections = [
                    .init([.totalCalories(day.totalCalories), .totalMacros(day.totalMacros)], headerString: "Summary"),
                    .init(mealsWithDisplayTimes.map(CellModel.meal), headerString: "Meals"),
                    .init([.addMeal])
                ]
                
                self.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.outputs.showMealEntry
            .observeOnUI()
            .subscribe(onNext: {
                self.navigationController?.pushViewController(MealEntryViewController(), animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.outputs.showAlertWithMessage
            .observeOnUI()
            .subscribe(onNext: { title, message in
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
                    self.tableView.deselectSelectedRows(animated: false)
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
    
}
